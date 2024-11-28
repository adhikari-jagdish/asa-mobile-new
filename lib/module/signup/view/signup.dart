import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sized_context/sized_context.dart';

import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/encrypt_decrypt_util.dart';
import '../../../common_utils/view_utils/app_loader.dart';
import '../../../routes/route_constants.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../../packages/bloc/country_code_update_cubit.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';
import '../widgets/signup_input_fields.dart';
import '../widgets/signup_top_section.dart';

class Signup extends StatelessWidget {
  Signup({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BlocListener<SignUpBloc, SignupState>(
        listener: (context, signupState) {
          if (signupState is LoadingSignupState) {
            BotToast.showLoading();
          } else if (signupState is OnErrorSignUpState) {
            BotToast.closeAllLoading();
            BotToast.showText(text: signupState.errorMessage!);
          } else if (signupState is OnSuccessSignUpState) {
            BotToast.closeAllLoading();
            Map<String, dynamic> formData = formKey.currentState!.value;
            Map<String, dynamic> tempFormData = {};
            tempFormData.addAll(formData);
            tempFormData.putIfAbsent('verificationId', () => signupState.verificationId);
            tempFormData.update('password', (value) => formData['password']);
            Navigator.pushNamed(
              context,
              RouteConstants.routeOtp,
              arguments: tempFormData,
            );
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: ScrollController(),
            child: Container(
              padding: EdgeInsets.only(left: 25.w, top: 35.h, right: 25.w,
                  bottom: 30.h),
              height: context.heightPx,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ).clickable(() {
                        Navigator.pop(context);
                      }),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: CommonStrings.alreadyAMember, style: CustomStyle.blackTextMedium),
                            TextSpan(
                              text: CommonStrings.signIn,
                              style: CustomStyle.blackTextMedium.copyWith(
                                color: CustomColor.color2a8dc8,
                              ),
                            )
                          ],
                        ),
                      ).clickable(() {
                        Navigator.pushReplacementNamed(context, RouteConstants.routeLogin);
                      }),
                    ],
                  ),
                  sboxH40,
                  const SignupTopSection(),
                  sboxH70,
                  SignupInputFields(formKey: formKey),
                  sboxH50,
                  SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (formKey.currentState!.saveAndValidate()) {
                            final code = context
                                .read<CountryCodeUpdateCubit>()
                                .state;
                            BlocProvider.of<SignUpBloc>(context).add(VerifyPhoneSignUpEvent(
                              context: context,
                              email: formKey.currentState!.value['email'],
                              mobileNumber: "+$code${formKey.currentState!
                                  .value['mobileNumber']}",
                              isResendCode: false,
                            ));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: CustomColor.color2a8dc8,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 300.w, minHeight: 50.h),
                            alignment: Alignment.center,
                            child: Text(
                              CommonStrings.signUp,
                              textAlign: TextAlign.center,
                              style: CustomStyle.whiteTextSemiBold.copyWith(fontSize: 18.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
