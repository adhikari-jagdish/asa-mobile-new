import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../module/signup/bloc/signup_bloc.dart';
import '../../../module/signup/bloc/signup_event.dart';

class FirebaseOtpService {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(
    BuildContext? context,
    String phoneNumber, {
    bool isForgetPassword = false,
    bool isMobileNumber = false,
    bool isResendCode = false,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (AuthCredential authCredential) {
        BotToast.showText(text: 'Your account is successfully verified.');
      },
      verificationFailed: (FirebaseAuthException authException) {
        BlocProvider.of<SignUpBloc>(context!).add(VerificationFailedSignUpEvent(errorMessage: authException.message));
      },
      codeSent: (String verId, [int? forceCodeResent]) {
        BlocProvider.of<SignUpBloc>(context!).add(CodeSentSignUpEvent(
          verificationId: verId,
          isResendCode: isResendCode,
        ));
      },
      codeAutoRetrievalTimeout: (String verId) {},
    );
  }
}
