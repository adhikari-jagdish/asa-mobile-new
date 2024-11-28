import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as flutter_secure;
import 'package:web_socket_channel/io.dart';

import '../../../common_utils/api_utils.dart';
import '../model/booking_request_model.dart';

class BookingApiService {
  static Dio dio = Dio(BaseOptions(
    baseUrl: ApiUtils.apiUrl,
  ))
    ..interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {
        String? accessToken = await const flutter_secure.FlutterSecureStorage().read(key: 'accessToken');
        options.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
        return handler.next(options);
      }, onResponse: (response, handler) async {
        final responseHeader = response.headers['authorization'];
        if (responseHeader != null) {
          await const flutter_secure.FlutterSecureStorage().write(key: 'accessToken', value: responseHeader[0].split('Bearer ')[1]);
        }
        return handler.next(response);
      }),
    );

  Future<Response> createBooking(BookingRequestModel bookingModel) async {
    print('Create Booking Model ${bookingModel.toJson()}');
    return await dio.post('createBooking', data: bookingModel.toJson());
  }

  Stream<dynamic> getBookingStream({required String userId}) {
    final channel = IOWebSocketChannel.connect('${ApiUtils.webSocketUrl}getBookingStream/$userId');
    return channel.stream;
  }

  Stream<dynamic> getNotificationsForUser({required String userId}) {
    final channel = IOWebSocketChannel.connect('${ApiUtils.webSocketUrl}getNotificationsForUser/$userId');
    return channel.stream;
  }
}
