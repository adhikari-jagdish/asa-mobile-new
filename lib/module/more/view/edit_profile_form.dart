import 'dart:convert';
import 'dart:io';

import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:asp_asia/module/more/bloc/user_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../assets/assets.dart';
import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/custom_button.dart';
import '../../../common_utils/view_utils/custom_login_textfield.dart';
import '../../../common_utils/view_utils/shared_preference_master.dart';
import '../../../common_utils/view_utils/utils.dart';
import '../../../theme/custom_color.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<String>(
      preference:
          RepositoryProvider.of<SharedPreferenceMaster>(context).userProfile,
      builder: (sContext, userProfile) {
        var userDetails = <String, dynamic>{};
        if (userProfile.isNotEmpty) {
          userDetails = json.decode(userProfile) as Map<String, dynamic>;
        }
        return FormBuilder(
          key: formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  (userDetails['image'] != null &&
                          userDetails['image'].toString().isNotEmpty)
                      ? ClipOval(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: userDetails['image'],
                            width: 100.w,
                            height: 100.h,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                SvgPicture.asset(
                              Assets.profileIcon,
                              width: 100,
                              height: 100,
                              color: CustomColor.color2a8dc8.withOpacity(0.8),
                            ),
                          ),
                        )
                      : SvgPicture.asset(
                          Assets.profileIcon,
                          width: 100,
                          height: 100,
                          color: CustomColor.color2a8dc8.withOpacity(0.8),
                        ),
                  Positioned(
                    child: GestureDetector(
                      onTap: () async {
                        final image = await Utils().pickImageFromGalley();
                        if (image.path != null) {
                          context.read<UserCubit>().uploadProfileImage(
                              image: File(image.path),
                              userDetails: userDetails);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: CustomColor.color2a8dc8.withOpacity(0.8),
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(
                          FontAwesomeIcons.cameraRetro,
                          color: Colors.white,
                          size: 13.0,
                        ),
                      ),
                    ),
                    bottom: 2.0,
                    right: 2.0,
                  )
                ],
              ),
              sboxH40,
              CustomTextFieldLogin(
                attribute: 'name',
                label: 'Full Name',
                initialValue: (userDetails['name'] != null &&
                        userDetails['name'].toString().isNotEmpty)
                    ? userDetails['name']
                    : null,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Full Name is required',
                  ),
                  FormBuilderValidators.minLength(6),
                ]),
              ),
              sboxH30,
              CustomTextFieldLogin(
                attribute: 'email',
                label: 'Email ID',
                initialValue: (userDetails['email'] != null &&
                        userDetails['email'].toString().isNotEmpty)
                    ? userDetails['email']
                    : null,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Email ID is required',
                  ),
                  FormBuilderValidators.email(),
                ]),
              ),
              sboxH30,
              CustomTextFieldLogin(
                attribute: 'address',
                label: 'Address',
                initialValue: (userDetails['address'] != null &&
                        userDetails['address'].toString().isNotEmpty)
                    ? userDetails['address']
                    : null,
                inputType: TextInputType.text,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Address is required',
                  ),
                ]),
              ),
              sboxH40,
              const CustomButton(buttonText: CommonStrings.submit).clickable(
                () {
                  if (formKey.currentState != null) {
                    if (formKey.currentState!.saveAndValidate()) {
                      context.read<UserCubit>().updateUser(
                            email: formKey.currentState!.value['email'],
                            fullName: formKey.currentState!.value['name'],
                            address: formKey.currentState!.value['address'],
                            userId: userDetails['userId'],
                            context: context,
                          );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
