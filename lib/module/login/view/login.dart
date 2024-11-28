import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:asp_asia/common_utils/custom_functions.dart';
import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sized_context/sized_context.dart';

import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/app_loader.dart';
import '../../../routes/route_constants.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../../packages/bloc/country_code_update_cubit.dart';
import '../cubit/login_cubit.dart';
import '../widgets/login_top_section.dart';
import '../widgets/login_username_password_fields.dart';

class Login extends StatelessWidget {
  Login({Key? key, this.userProfile}) : super(key: key);
  final formKey = GlobalKey<FormBuilderState>();
  final Map<String, dynamic>? userProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, loginState) {
            if (loginState is LoginLoading) {
              BotToast.showLoading();
            } else if (loginState is LoginSuccess) {
              BotToast.closeAllLoading();
              BotToast.showText(text: 'Login Success');
              Navigator.pop(context);
            } else if (loginState is LoginError) {
              BotToast.closeAllLoading();
              BotToast.showText(text: loginState.errorMessage);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: ScrollController(),
            child: Container(
              padding: EdgeInsets.only(
                  left: 25.w, top: 30.h, right: 25.w, bottom: 30.h),
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
                            const TextSpan(
                                text: CommonStrings.newUser,
                                style: CustomStyle.blackTextMedium),
                            TextSpan(
                              text: CommonStrings.signUp,
                              style: CustomStyle.blackTextMedium.copyWith(
                                color: CustomColor.color2a8dc8,
                              ),
                            )
                          ],
                        ),
                      ).clickable(() {
                        Navigator.pushReplacementNamed(
                            context, RouteConstants.routeSignUp);
                      }),
                    ],
                  ),
                  sboxH40,
                  const LoginTopSection(),
                  sboxH70,
                  LoginUsernamePasswordFields(
                    formKey: formKey,
                  ),
                  sboxH10,
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, RouteConstants.routeForgotPassword),
                      child: const Text(
                        CommonStrings.forgotPassword,
                        style: CustomStyle.blackTextMedium,
                      ),
                    ),
                  ),
                  sboxH50,
                  SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (formKey.currentState!.saveAndValidate()) {
                            BlocProvider.of<LoginCubit>(context).login(
                              username: formKey.currentState!.value['username'],
                              password: formKey.currentState!.value['password'],
                              context: context,
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: CustomColor.color2a8dc8,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.w, minHeight: 50.h),
                            alignment: Alignment.center,
                            child: Text(
                              CommonStrings.login,
                              textAlign: TextAlign.center,
                              style: CustomStyle.whiteTextSemiBold
                                  .copyWith(fontSize: 18.sp),
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
