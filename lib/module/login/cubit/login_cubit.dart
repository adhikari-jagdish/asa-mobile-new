import 'dart:convert';

import 'package:asp_asia/module/login/service/login_api_service.dart';
import 'package:asp_asia/services/firebase/firebaseMessaging/firebase_cloud_messaging_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../common_utils/api_utils.dart';
import '../../../common_utils/common_strings.dart';
import '../../../common_utils/encrypt_decrypt_util.dart';
import '../../../common_utils/view_utils/utils.dart';
import '../../packages/bloc/country_code_update_cubit.dart';
import '../model/firebase_token_model.dart';
import '../model/userModel.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.loginApiService,
    required this.firebaseCloudMessagingServices,
    required this.flutterSecureStorage,
    required this.sharedPreferences,
  }) : super(LoginInitial());

  final LoginApiService loginApiService;
  final FirebaseCloudMessagingServices firebaseCloudMessagingServices;
  final StreamingSharedPreferences? sharedPreferences;
  final FlutterSecureStorage? flutterSecureStorage;

  void login(
      {required String? username,
      required String? password,
      required BuildContext context}) async {
    emit(LoginLoading());
    try {
      String? uName = '';
      final code = context.read<CountryCodeUpdateCubit>().state;
      if (username != null) {
        if (Utils().isEmail(username)) {
          uName = username;
        } else {
          uName = '+$code$username';
        }
      }

      final response = await loginApiService.login(
          username: uName.trim(), password: password!.trim());
      print('Response ${response.statusCode}');
      if (response.statusCode! >= 400) {
        ApiUtils.handleHttpException(response);
      }
      final messageAndData =
          ApiUtils.getMessageTokensAndSingleDataFromResponse(response);

      final loginResponse = UserModel.fromJson(messageAndData.data[0]);
      final fcmToken =
          await firebaseCloudMessagingServices.getTokenForPushNotification();
      FirebaseTokenModel firebaseTokenModel =
          FirebaseTokenModel(userId: loginResponse.userId, token: fcmToken);
      await loginApiService.addUpdateFirebaseToken(
          firebaseTokenModel: firebaseTokenModel);
      await flutterSecureStorage!
          .write(key: 'accessToken', value: messageAndData.accessToken);
      await sharedPreferences!.setString(
        CommonStrings.sharedPrefUserProfile,
        jsonEncode({
          'userId': loginResponse.userId,
          'name': loginResponse.fullName,
          'mobileNumber': loginResponse.mobileNumber,
          'email': loginResponse.email,
          'image': loginResponse.profileImage ?? '',
        }),
      );
      emit(LoginSuccess(userModel: loginResponse));
    } catch (e) {
      emit(
          const LoginError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}
