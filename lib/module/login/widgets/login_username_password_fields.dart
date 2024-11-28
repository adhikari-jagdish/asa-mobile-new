import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mmoo_country_pickers/country.dart';
import 'package:mmoo_country_pickers/mmoo_country_pickers.dart';

import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/custom_login_mobilefield.dart';
import '../../../common_utils/view_utils/custom_login_textfield.dart';
import '../../../theme/custom_style.dart';
import '../../packages/bloc/country_code_update_cubit.dart';
import '../cubit/password_toggle_cubit.dart';
import '../cubit/username_toggle_cubit.dart';

class LoginUsernamePasswordFields extends StatelessWidget {
  const LoginUsernamePasswordFields({Key? key, required this.formKey})
      : super(key: key);
  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: BlocBuilder<UsernameToggleBloc, bool>(
        builder: (context, shouldShowEmail) {
          return Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Text(
                    shouldShowEmail ? 'Use mobile' : 'Use email',
                    style: CustomStyle.blackTextRegular.copyWith(
                      fontSize: 10.sp,
                    ),
                  ).clickable(() {
                    BlocProvider.of<UsernameToggleBloc>(context)
                        .emit(!shouldShowEmail);
                  }),
                ],
              ),
              sboxH10,
              shouldShowEmail
                  ? CustomTextFieldLogin(
                      attribute: 'username',
                      label: 'Email',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: 'Email is required',
                        ),
                        FormBuilderValidators.minLength(6),
                        FormBuilderValidators.email(errorText: 'Invalid Email'),
                      ]),
                      valueTransformer: (val) {
                        if (val != null) {
                          return val.toString().trim();
                        }
                      },
                    )
                  : Wrap(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.2,
                          child: SizedBox(
                            width: 70.w,
                            child: CountryPickerDropdown(
                              itemBuilder: (Country country) => Row(
                                children: <Widget>[
                                  CountryPickerUtils.getDefaultFlagImage(
                                      country),
                                ],
                              ),
                              initialValue: 'US',
                              itemFilter: (c) => [
                                'AR',
                                'AU',
                                'AT',
                                'BH',
                                'BD',
                                'BE',
                                'BR',
                                'BG',
                                'CA',
                                'CO',
                                'DK',
                                'EG',
                                'FR',
                                'DE',
                                'HK',
                                'IN',
                                'ID',
                                'IR',
                                'IE',
                                'IT',
                                'JP',
                                'KR',
                                'MY',
                                'NP',
                                'NL',
                                'NZ',
                                'NO',
                                'PK',
                                'PH',
                                'PT',
                                'RO',
                                'SG',
                                'ES',
                                'LK',
                                'SE',
                                'TR',
                                'GB',
                                'US',
                                'VN',
                                'CN',
                              ].contains(c.isoCode),
                              //priorityList is shown at the beginning of list
                              priorityList: [
                                CountryPickerUtils.getCountryByIsoCode('GB')!,
                                CountryPickerUtils.getCountryByIsoCode('US')!,
                                CountryPickerUtils.getCountryByIsoCode('CA')!,
                              ],
                              sortComparator: (Country a, Country b) =>
                                  a.isoCode.compareTo(b.isoCode),
                              onValuePicked: (Country country) {
                                context
                                    .read<CountryCodeUpdateCubit>()
                                    .emit(country.phoneCode);
                              },
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: CustomMobileFieldLogin(
                            attribute: 'username',
                            label: 'Mobile No',
                            inputType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                errorText: 'Mobile number is required',
                              ),
                              FormBuilderValidators.minLength(10,
                                  errorText:
                                      'Mobile number should be of 10 digits'),
                              FormBuilderValidators.maxLength(10,
                                  errorText:
                                      'Mobile number should be of 10 digits'),
                              FormBuilderValidators.numeric(
                                  errorText: 'Invalid Mobile number'),
                            ]),
                          ),
                        )
                      ],
                    ),
              sboxH30,
              BlocBuilder<PasswordToggleCubit, bool>(
                builder: (context, showOrHide) {
                  return CustomTextFieldLogin(
                    attribute: 'password',
                    label: 'Password',
                    obscureText: !showOrHide,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        context.read<PasswordToggleCubit>().emit(!showOrHide);
                      },
                      child: showOrHide
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: 'Password is required',
                      ),
                      FormBuilderValidators.minLength(6),
                    ]),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
