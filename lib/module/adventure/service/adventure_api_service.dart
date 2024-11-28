import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as flutter_secure;
import 'package:dio/dio.dart';

import '../../../common_utils/api_utils.dart';

class AdventureApiService {
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

  Future<Response> getAdventurePackagesByDestinationId(String destinationId) async {
    return await dio.get('getAdventurePackagesByDestinationId/$destinationId');
  }

  Future<Response> getAdventurePackagesByTravelThemeId(String travelThemeId) async {
    return await dio.get('getAdventurePackagesByTravelThemeId/$travelThemeId');
  }
}
