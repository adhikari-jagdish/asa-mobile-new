import 'dart:convert';

import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:asp_asia/module/signup/service/signup_api_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../common_utils/api_utils.dart';
import '../../../common_utils/encrypt_decrypt_util.dart';
import '../../../services/firebase/firebaseAuth/firebase_auth_service.dart';
import '../../../services/firebase/firebaseAuth/firebase_otp_service.dart';
import '../../../services/firebase/firebaseMessaging/firebase_cloud_messaging_service.dart';
import '../../login/model/firebase_token_model.dart';
import '../../login/model/userModel.dart';
import '../../packages/bloc/country_code_update_cubit.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignupState> {
  final FirebaseOtpService firebaseOtpServices;
  final FirebaseAuthServices firebaseAuthServices;
  final StreamingSharedPreferences? sharedPreferences;
  final SignupApiService signupApiService;
  final FlutterSecureStorage? flutterSecureStorage;
  final FirebaseCloudMessagingServices? firebaseCloudMessagingServices;

  SignUpBloc({
    required this.firebaseOtpServices,
    required this.firebaseAuthServices,
    required this.sharedPreferences,
    required this.signupApiService,
    required this.flutterSecureStorage,
    required this.firebaseCloudMessagingServices,
  }) : super(InitialSignupState());

  @override
  Stream<SignupState> mapEventToState(SignUpEvent event) async* {
    if (event is VerifyPhoneSignUpEvent) {
      yield* mapVerifyPhoneSignUpEventEventToState(event);
    } else if (event is CodeSentSignUpEvent) {
      yield* mapCodeSentSignUpEventEventToState(event);
    } else if (event is SignInSignUpEvent) {
      yield* mapSignInSignUpEventToState(event);
    } else if (event is VerificationFailedSignUpEvent) {
      yield* mapVerificationFailedSignUpEventToState(event);
    } else if (event is LogoutSignUpEvent) {
      yield* mapLogoutSignUpEventToState(event);
    } else if (event is ResetPasswordSignUpEvent) {
      yield* mapResetPasswordSignUpEventEventToState(event);
    } else if (event is SetNewPasswordSignUpEvent) {
      yield* mapSetNewPasswordSignUpEventToState(event);
    }
  }

  Stream<SignupState> mapVerifyPhoneSignUpEventEventToState(
      VerifyPhoneSignUpEvent event) async* {
    yield LoadingSignupState();
    print('Mobile Number ${event.mobileNumber}');
    try {
      UserModel? userCheckEmail;
      UserModel? userCheckMobileNumber;
      try {
        final response = await signupApiService.checkUserPresenceWithEmail(
            email: event.email!);
        if (response.statusCode! >= 400) {
          throw ApiUtils.handleHttpException(response);
        }
        final messageAndData =
            ApiUtils.getMessageAndSingleDataFromResponse(response);
        userCheckEmail = UserModel.fromJson(messageAndData.data[0]);
      } catch (e) {}
      if (userCheckEmail != null) {
        throw 'Email already exists.';
      }
      try {
        final response =
            await signupApiService.checkUserPresenceWithMobileNumber(
                mobileNumber: event.mobileNumber!);
        if (response.statusCode! >= 400) {
          throw ApiUtils.handleHttpException(response);
        }
        final messageAndData =
            ApiUtils.getMessageAndSingleDataFromResponse(response);
        userCheckMobileNumber = UserModel.fromJson(messageAndData.data[0]);
      } catch (e) {}
      if (userCheckMobileNumber != null) {
        throw 'Mobile number already exists.';
      }
      if (userCheckEmail == null && userCheckMobileNumber == null) {
        String mobileNumber = event.mobileNumber!;
        await firebaseOtpServices.verifyPhoneNumber(
          event.context,
          mobileNumber,
          isResendCode: event.isResendCode,
        );
      }
    } on FirebaseException catch (e) {
      yield OnErrorSignUpState(errorMessage: '${e.message}');
    } catch (e) {
      yield OnErrorSignUpState(errorMessage: e.toString());
    }
  }

  Stream<SignupState> mapCodeSentSignUpEventEventToState(
      CodeSentSignUpEvent event) async* {
    await sharedPreferences!
        .setBool(CommonStrings.sharedPrefIsVerifyOtpCode, false);
    await sharedPreferences!.setString(
        CommonStrings.sharedPrefOtpVerificationId, event.verificationId!);
    yield OnSuccessSignUpState(
        verificationId: event.verificationId, isResendCode: event.isResendCode);
  }

  Stream<SignupState> mapSignInSignUpEventToState(
      SignInSignUpEvent event) async* {
    yield LoadingSignupState();
    UserModel? userModel;
    try {
      final code = event.context?.read<CountryCodeUpdateCubit>().state;
      Map<String, dynamic> formData = event.formData!;
      final phoneAuthCredential = await firebaseAuthServices.getPhoneCredential(
          event.verificationId!, event.otpCode!);
      final emailAuthCredential = await firebaseAuthServices.getEmailCredential(
          formData['email'].toString().trim(),
          formData['password'].toString().trim());
      final phoneUserCredential =
          await firebaseAuthServices.signInWithCredentials(phoneAuthCredential);
      var combineAuthCredential = await phoneUserCredential.user!
          .linkWithCredential(emailAuthCredential);
      formData.putIfAbsent('uId', () => combineAuthCredential.user!.uid);
      formData.putIfAbsent('isVerified', () => true);
      formData.putIfAbsent('status', () => 'Active');
      userModel = UserModel.fromFormMap(formData);
      userModel.mobileNumber = "+$code${formData['mobileNumber']}";
      userModel.userType = CommonStrings.userType;
      userModel.password?.trim();

      ///Get Roles and Permissions for customer
      final roleResponse =
          await signupApiService.getRoleByName(role: CommonStrings.customer);
      if (roleResponse.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(roleResponse);
      }
      final roleMessageAndData =
          ApiUtils.getMessageAndSingleDataFromResponse(roleResponse);
      final roleId = roleMessageAndData.data[0]['_id'];
      userModel.role = roleId;
      final response = await signupApiService.createUser(userModel: userModel);
      if (response.statusCode! >= 400) {
        throw ApiUtils.handleHttpException(response);
      }
      final responseHeader = response.headers['authorization'];
      print('Signup Response ${response.statusCode}');
      if (response.statusCode == 200) {
        final messageAndData =
            ApiUtils.getMessageTokensAndSingleDataFromResponse(response);
        final userResponse = UserModel.fromJson(messageAndData.data[0]);
        print('User Response ${userResponse.toMap()}');
        final fcmToken =
            await firebaseCloudMessagingServices!.getTokenForPushNotification();
        FirebaseTokenModel firebaseTokenModel =
            FirebaseTokenModel(userId: userResponse.userId, token: fcmToken);
        await flutterSecureStorage!.write(
            key: 'accessToken', value: responseHeader![0].split('Bearer ')[1]);
        await sharedPreferences!
            .setBool(CommonStrings.sharedPrefIsLoggedIn, true);
        await sharedPreferences!
            .setBool(CommonStrings.sharedPrefIsVerifyOtpCode, true);
        await sharedPreferences!.setString(
          CommonStrings.sharedPrefUserProfile,
          jsonEncode({
            'userId': userResponse.userId,
            'name': userResponse.fullName,
            'mobileNumber': userResponse.mobileNumber,
            'email': userResponse.email,
            'image': userResponse.profileImage ?? '',
            'address': userModel.address ?? '',
          }),
        );
        await signupApiService.addUpdateFirebaseToken(
            firebaseTokenModel: firebaseTokenModel);
        yield OnSuccessSignUpState(
            user: combineAuthCredential.user,
            userModel: userResponse,
            context: event.context);
      } else {
        yield OnErrorSignUpState(
            errorMessage: CommonStrings.oopsSomethingWentWrong);
      }
    } on FirebaseException catch (e) {
      yield OnErrorSignUpState(errorMessage: '${e.message}');
    } on DioException catch (e) {
      String errorMessage = CommonStrings.oopsSomethingWentWrong;
      if (e.response != null && e.response!.data != null) {
        errorMessage = e.response!.data['message'];
      }
      print('Signup Dio error $e');
      yield OnErrorSignUpState(errorMessage: errorMessage);
    } catch (e) {
      print('Signup Catch $e');
      await firebaseAuthServices.deleteFirebaseUser();
      if (userModel != null) {
        await signupApiService.deleteUserById(uId: userModel.uId!);
      }
      print('Signup Exception $e');
      yield OnErrorSignUpState(
          errorMessage: e.toString());
    }
  }

  Stream<SignupState> mapVerificationFailedSignUpEventToState(
      VerificationFailedSignUpEvent event) async* {
    yield OnErrorSignUpState(
        errorMessage: event.errorMessage);
  }

  Stream<SignupState> mapLogoutSignUpEventToState(
      LogoutSignUpEvent event) async* {
    yield LoadingSignupState();
    try {
      await firebaseAuthServices.logoutFirebase();
      yield OnSuccessSignUpState();
      yield OnLogoutSignupState();
    } on FirebaseException catch (e) {
      yield OnErrorSignUpState(errorMessage: '${e.message}');
    } catch (e) {
      yield OnErrorSignUpState(
          errorMessage: CommonStrings.oopsSomethingWentWrong);
    }
  }

  Stream<SignupState> mapResetPasswordSignUpEventEventToState(
      ResetPasswordSignUpEvent event) async* {
    yield LoadingSignupState();

    try {
      UserModel? userCheckMobileNumber;
      final code = event.context?.read<CountryCodeUpdateCubit>().state;
      String mobileNumber = "+$code${event.mobileNumber!}";
      try {
        final response = await signupApiService
            .checkUserPresenceWithMobileNumber(mobileNumber: mobileNumber);
        if (response.statusCode! >= 400) {
          throw ApiUtils.handleHttpException(response);
        }
        final messageAndData =
            ApiUtils.getMessageAndSingleDataFromResponse(response);
        userCheckMobileNumber = UserModel.fromJson(messageAndData.data[0]);
      } catch (e) {}
      if (userCheckMobileNumber == null) {
        throw 'Mobile number doesn\'t exists.';
      }

      await firebaseOtpServices.verifyPhoneNumber(
        event.context,
        mobileNumber,
        isForgetPassword: event.isForgetPassword,
      );
    } catch (e) {
      yield OnErrorSignUpState(errorMessage: e.toString());
    }
  }

  Stream<SignupState> mapSetNewPasswordSignUpEventToState(
      SetNewPasswordSignUpEvent event) async* {
    yield LoadingSignupState();
    try {
      final phoneAuthCredential = await firebaseAuthServices.getPhoneCredential(
          event.verificationId!, event.otpCode!);
      final phoneUserCredential =
          await firebaseAuthServices.signInWithCredentials(phoneAuthCredential);
      yield OnSuccessSignUpState(
        verificationId: event.verificationId,
        isForgetPassword: event.isForgetPassword,
        user: phoneUserCredential.user,
      );
    } on FirebaseException catch (e) {
      yield OnErrorSignUpState(errorMessage: '${e.message}');
    } catch (e) {
      yield OnErrorSignUpState(
          errorMessage: CommonStrings.oopsSomethingWentWrong);
    }
  }
}
