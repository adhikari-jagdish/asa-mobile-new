import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as flutter_secure;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import '../../../common_utils/api_utils.dart';
import '../model/firebase_token_model.dart';

class LoginApiService {
  static Dio dio = Dio(BaseOptions(
    baseUrl: ApiUtils.userAuthApiUrl,
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

  Future<Response> login({required String username, required String password}) async {
    return await dio.post('signInUser', data: {'username': username, 'password': password});
  }

  ///Firebase FCM Token
  Future<Response> addUpdateFirebaseToken({required FirebaseTokenModel firebaseTokenModel}) async {
    return await dio.post('addUpdateFirebaseToken', data: firebaseTokenModel.toJson());
  }

  Future<Response> updateProfile({String? fullName, String? address, String? email, String? userId}) async {
    Map<String, String> request = {
      'fullName': fullName!,
      'address': address!,
      'email': email!,
    };
    return await dio.put('updateProfile/$userId', data: request);
  }

  ///Upload Profile Image
  Future<Response> uploadProfileImage({String? userId, File? file}) async {
    var len = await file!.length();
    String fileName = file.path.split('/').last;
    String mimeType = extension(file.path).replaceAll(".", "");
    var formData = FormData.fromMap({
      'userId': userId,
      'file': MultipartFile(file.openRead(), len, filename: fileName, contentType: MediaType('image', mimeType)),
    });
    final response = await dio.post(
      'updateProfileImage',
      data: formData,
      options: Options(headers: {
        Headers.contentTypeHeader: "multipart/form-data",
      }),
    );
    return response;
  }
}
