import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class SignUpEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialSignUpEvent extends SignUpEvent {}

class LogoutSignUpEvent extends SignUpEvent {}

class VerifyPhoneSignUpEvent extends SignUpEvent {
  final BuildContext? context;
  final String? mobileNumber;
  final String? email;
  final bool isResendCode;

  VerifyPhoneSignUpEvent({
    this.context,
    this.mobileNumber,
    this.email,
    this.isResendCode = false,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    context,
    mobileNumber,
    email,
    isResendCode,
  ];
}

class ResetPasswordSignUpEvent extends SignUpEvent {
  final BuildContext? context;
  final String? mobileNumber;
  final bool isForgetPassword;

  ResetPasswordSignUpEvent({
    this.isForgetPassword = false,
    required this.mobileNumber,
    this.context,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    isForgetPassword,
    mobileNumber,
    context,
  ];
}

class CodeAuthRetrievalTimeoutSignUpEvent extends SignUpEvent {
  final String? errorMessage;

  CodeAuthRetrievalTimeoutSignUpEvent({this.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}

class CodeSentSignUpEvent extends SignUpEvent {
  final String? verificationId;
  final bool isResendCode;
  final bool isForgetPassword;

  CodeSentSignUpEvent({
    this.verificationId,
    this.isResendCode = false,
    this.isForgetPassword = false,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [verificationId, isResendCode, isForgetPassword];
}

class SetNewPasswordSignUpEvent extends SignUpEvent {
  final String? verificationId;
  final String? otpCode;
  final BuildContext? context;
  final bool isForgetPassword;

  SetNewPasswordSignUpEvent({
    this.context,
    this.otpCode,
    this.verificationId,
    this.isForgetPassword = false,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    context,
    otpCode,
    verificationId,
    isForgetPassword,
  ];
}

class VerificationCompletedSignUpEvent extends SignUpEvent {
  final AuthCredential? authCredential;

  VerificationCompletedSignUpEvent({this.authCredential});

  @override
  // TODO: implement props
  List<Object?> get props => [authCredential];
}

class VerificationFailedSignUpEvent extends SignUpEvent {
  final String? errorMessage;

  VerificationFailedSignUpEvent({this.errorMessage = "Phone authentication failed."});

  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}

class SignInSignUpEvent extends SignUpEvent {
  final String? verificationId;
  final String? otpCode;
  final Map<String, dynamic>? formData;
  final BuildContext? context;

  SignInSignUpEvent({
    this.verificationId,
    this.otpCode,
    this.formData,
    this.context,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    verificationId,
    otpCode,
    formData,
    context,
  ];
}
