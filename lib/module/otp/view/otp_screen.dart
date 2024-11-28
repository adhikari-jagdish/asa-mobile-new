import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sized_context/sized_context.dart';

import '../../../assets/assets.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/app_loader.dart';
import '../../../routes/route_constants.dart';
import '../../../theme/custom_style.dart';
import '../../signup/bloc/signup_bloc.dart';
import '../../signup/bloc/signup_state.dart';
import '../widget/otp_pin_code_field.dart';
import '../widget/otp_resend_widget.dart';
import '../widget/otp_submit_button.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key, this.formData}) : super(key: key);
  final Map<String, dynamic>? formData;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BlocListener<SignUpBloc, SignupState>(
        listener: (bContext, signupState) {
          if (signupState is OnSuccessSignUpState) {
            if (signupState.user != null && signupState.userModel != null) {
              BotToast.closeAllLoading();
              BotToast.showText(text: 'User Registered and Logged In Successfully');
              Navigator.popUntil(context, (route) => route.settings.name == RouteConstants.routeDashboardBottomNav);
              /* Navigator.pushNamedAndRemoveUntil(
                context,
                RouteConstants.routeDashboardBottomNav,
                (route) => false,
                arguments: signupState.userModel,
              );*/
            } else if (signupState.isResendCode) {
              BotToast.showText(text: 'Otp has been resent successfully');
            } else if (signupState.isForgetPassword) {
              Navigator.pushReplacementNamed(
                context,
                RouteConstants.routeSetNewPassword,
                arguments: [signupState.user!.uid],
              );
            }
          } else if (signupState is LoadingSignupState) {
            BotToast.showLoading();
          } else if (signupState is OnErrorSignUpState) {
            BotToast.closeAllLoading();
            BotToast.showText(text: signupState.errorMessage!);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Verification',
              style: CustomStyle.blackTextMedium,
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: ScrollController(),
              child: Container(
                width: context.widthPx,
                padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.verifyOtpIcon,
                      width: 150.w,
                      height: 150.h,
                    ),
                    sboxH20,
                    Text(
                      CommonStrings.descriptionText,
                      style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 18.sp),
                      textAlign: TextAlign.center,
                    ),
                    sboxH20,
                    const OtpPinCodeField(),
                    sboxH20,
                    OtpResendWidget(
                      formData: formData,
                    ),
                    sboxH20,
                    OtpSubmitButton(formData: formData),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
