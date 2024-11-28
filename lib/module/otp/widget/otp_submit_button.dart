import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_utils/common_strings.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../../signup/bloc/signup_bloc.dart';
import '../../signup/bloc/signup_event.dart';
import '../bloc/otp_value_update_cubit.dart';

class OtpSubmitButton extends StatelessWidget {
  const OtpSubmitButton({Key? key, required this.formData}) : super(key: key);

  final Map<String, dynamic>? formData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: const EdgeInsets.all(0.0),
        ),
        child: BlocBuilder<OtpValueUpdateCubit, String>(
          builder: (context, otpValue) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<SignUpBloc>(context).add(SignInSignUpEvent(
                  verificationId: formData!['verificationId'],
                  otpCode: otpValue,
                  formData: formData,
                  context: context,
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                   color: CustomColor.color2a8dc8,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.w, minHeight: 50.h),
                  alignment: Alignment.center,
                  child: Text(
                    CommonStrings.verify,
                    textAlign: TextAlign.center,
                    style: CustomStyle.whiteTextSemiBold.copyWith(fontSize: 18.sp),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
