import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sized_context/sized_context.dart';

import '../../../common_utils/view_utils/app_loader.dart';
import '../bloc/user_cubit.dart';
import 'edit_profile_form.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ).clickable(() {
          Navigator.of(context).pop();
        }),
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, userState) {
          if (userState is UserLoading) {
            BotToast.showCustomLoading(toastBuilder: (_) {
              return const AppLoader();
            });
          } else if (userState is UserSuccess) {
            BotToast.closeAllLoading();
            BotToast.showText(text: userState.successMessage!);
            if (userState.isImageUpdate != null) {
              if (!userState.isImageUpdate!) {
                Navigator.of(context).pop();
              }
            }
          } else if (userState is UserError) {
            BotToast.closeAllLoading();
            BotToast.showText(text: userState.errorMessage!);
          }
        },
        child: SafeArea(
          child: Container(
            width: context.widthPx,
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: ScrollController(),
              child: Column(
                children: [
                  EditProfileForm(formKey: formKey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
