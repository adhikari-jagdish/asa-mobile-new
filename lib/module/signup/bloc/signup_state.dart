import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../login/model/userModel.dart';

abstract class SignupState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialSignupState extends SignupState {}

class LoadingSignupState extends SignupState {}

class OnLogoutSignupState extends SignupState {}

class OnSuccessSignUpState extends SignupState {
  final String? verificationId;
  final User? user;
  final bool isResendCode;
  final UserModel? userModel;
  final BuildContext? context;
  final bool isForgetPassword;

  OnSuccessSignUpState({
    this.verificationId,
    this.user,
    this.isResendCode = false,
    this.userModel,
    this.context,
    this.isForgetPassword = false,
  });

  @override
  List<Object?> get props => [
        verificationId,
        user,
        isResendCode,
        userModel,
        context,
        isForgetPassword,
      ];
}

class OnErrorSignUpState extends SignupState {
  final String? errorMessage;

  OnErrorSignUpState({this.errorMessage});

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}
