import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as flutter_secure;
import '../../../common_utils/api_utils.dart';
import '../../login/model/firebase_token_model.dart';
import '../../login/model/userModel.dart';

class SignupApiService {
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

  Future<Response> createUser({required UserModel userModel}) async {
    return await dio.post('createUser', data: userModel.toMap());
  }

  Future<dynamic> deleteUserById({required String uId}) async {
    return (await dio.delete('deleteUserByUid/$uId')).data;
  }

  Future<Response> checkUserPresenceWithMobileNumber({required String mobileNumber}) async {
    return await dio.get('checkUserPresenceWithMobileNumber/$mobileNumber');
  }

  Future<Response> checkUserPresenceWithEmail({required String email}) async {
    return await dio.get('checkUserPresenceWithEmail/$email');
  }

  Future<dynamic> addUpdateFirebaseToken({required FirebaseTokenModel firebaseTokenModel}) async {
    return await dio.post('addUpdateFirebaseToken', data: firebaseTokenModel.toJson());
  }

  Future<Response> getRoleByName({required String role}) async {
    return await dio.get('getRoleByName/$role');
  }
}
