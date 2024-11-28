import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_utils/common_strings.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../../signup/bloc/signup_bloc.dart';
import '../../signup/bloc/signup_event.dart';

class OtpResendWidget extends StatelessWidget {
  const OtpResendWidget({Key? key, required this.formData}) : super(key: key);

  final Map<String, dynamic>? formData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.h),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () {
            BlocProvider.of<SignUpBloc>(context).add(VerifyPhoneSignUpEvent(
              context: context,
              email: formData!['email'],
              mobileNumber: '+977' + formData!['mobileNumber'],
              isResendCode: true,
            ));
          },
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(text: CommonStrings.didntReceiveCode, style: CustomStyle.blackTextMedium),
              TextSpan(
                text: CommonStrings.resend,
                style: CustomStyle.blackTextMedium.copyWith(
                  color: CustomColor.colorF58420,
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
