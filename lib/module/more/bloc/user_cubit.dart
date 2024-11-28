import 'dart:convert';
import 'dart:io';

import 'package:asp_asia/module/login/service/login_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../common_utils/api_utils.dart';
import '../../../common_utils/common_strings.dart';
import '../../login/model/userModel.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required this.loginApiService, required this.sharedPreferences}) : super(UserInitial());

  final StreamingSharedPreferences? sharedPreferences;
  final LoginApiService loginApiService;

  void updateUser({
    required String email,
    required String fullName,
    required String address,
    required String userId,
    required BuildContext context,
  }) async {
    emit(UserLoading());
    try {
      final response = await loginApiService.updateProfile(
        email: email,
        fullName: fullName,
        address: address,
        userId: userId,
      );
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndSingleDataFromResponse(response);
      final userModel = UserModel.fromJson(messageAndData.data[0]);
      await sharedPreferences!.setString(
        CommonStrings.sharedPrefUserProfile,
        jsonEncode({
          'userId': userModel.userId,
          'name': userModel.fullName,
          'mobileNumber': userModel.mobileNumber,
          'email': userModel.email,
          'address': userModel.address,
          'image': userModel.profileImage,
        }),
      );
      emit(UserSuccess(successMessage: messageAndData.message, isImageUpdate: false, context: context));
    } catch (e) {
      print(e);
      emit(const UserError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }

  void uploadProfileImage({required File? image, required Map<String, dynamic>? userDetails}) async {
    emit(UserLoading());
    try {
      final response = await loginApiService.uploadProfileImage(userId: userDetails!['userId'], file: image);
      print('Response $response');
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final messageAndData = ApiUtils.getMessageAndSingleDataFromResponse(response);
      final userModel = UserModel.fromJson(messageAndData.data[0]);
      await sharedPreferences!.setString(
        CommonStrings.sharedPrefUserProfile,
        jsonEncode({
          'userId': userModel.userId,
          'name': userModel.fullName,
          'mobileNumber': userModel.mobileNumber,
          'email': userModel.email,
          'image': userModel.profileImage,
          'address': userModel.address,
        }),
      );
      emit(UserSuccess(successMessage: messageAndData.message));
    } catch (e) {
      print('Image Error $e');
      emit(const UserError(errorMessage: CommonStrings.oopsSomethingWentWrong));
    }
  }
}
