import 'dart:convert';

import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:asp_asia/common_utils/custom_sized_box.dart';
import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:asp_asia/services/firebase/firebaseAuth/firebase_auth_service.dart';
import 'package:asp_asia/theme/custom_color.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_utils/view_utils/custom_cupertino_alert_dialog.dart';
import '../../../common_utils/view_utils/custom_webview.dart';
import '../../../common_utils/view_utils/shared_preference_master.dart';
import 'more_top_profile_card.dart';
import 'settings_options_layout.dart';

class More extends StatelessWidget {
  const More({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                const MoreTopProfileCard(),
                sboxH10,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SettingsOptionsLayout(
                        icon: const Icon(
                          Icons.note_rounded,
                          color: CustomColor.color2a8dc8,
                        ),
                        title: 'Legal Documents',
                        subTitle: 'Check out our registration documents',
                        onClicked: () =>
                            PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const CustomWebView(
                            webUrl: CommonStrings.legalDocumentsUrl,
                          ),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      SettingsOptionsLayout(
                        icon: const Icon(
                          Icons.branding_watermark_sharp,
                          color: Colors.deepPurple,
                        ),
                        title: 'Terms & Conditions',
                        subTitle: 'View our Terms & Conditions',
                        onClicked: () =>
                            PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const CustomWebView(
                            webUrl: CommonStrings.termsAndConditionsUrl,
                          ),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      SettingsOptionsLayout(
                        icon: const Icon(
                          Icons.person_pin,
                          color: Colors.teal,
                        ),
                        title: 'About Us',
                        subTitle: 'Learn more about Aspiration Asia',
                        onClicked: () =>
                            PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const CustomWebView(
                            webUrl: CommonStrings.aboutUsUrl,
                          ),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      SettingsOptionsLayout(
                        icon: const Icon(
                          Icons.call,
                          color: Colors.deepOrange,
                        ),
                        title: 'Contact Us',
                        subTitle: 'Connect with us directly via call or mail',
                        onClicked: () {
                          try {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'info@aspirationasia.com',
                            );
                            launchUrl(emailLaunchUri);
                          } catch (e) {
                            BotToast.showText(
                                text: CommonStrings.oopsSomethingWentWrong);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                sboxH20,
                SettingsOptionsLayout(
                  icon: const Icon(
                    Icons.feedback,
                    color: Colors.pink,
                  ),
                  title: 'Send Feedback',
                  subTitle: 'Let us know how we can make the app better',
                  onClicked: () =>
                      BotToast.showText(text: 'Feature coming soon'),
                ),
                sboxH20,
                PreferenceBuilder<String>(
                  preference:
                      RepositoryProvider.of<SharedPreferenceMaster>(context)
                          .userProfile,
                  builder: (context, userProfile) {
                    var userDetails = {};
                    if (userProfile.isNotEmpty) {
                      userDetails =
                          json.decode(userProfile) as Map<String, dynamic>;
                    }
                    if (userDetails.isNotEmpty) {
                      return SettingsOptionsLayout(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.orangeAccent,
                        ),
                        title: 'Sign Out',
                        subTitle: 'Log off from your session',
                      ).clickable(
                        () async {
                          String? token =
                              await RepositoryProvider.of<FlutterSecureStorage>(
                                      context)
                                  .read(key: 'accessToken');
                          if (token != null && token.isNotEmpty) {
                            await showDialog(
                              context: context,
                              builder: (dContext) {
                                return CustomCupertinoAlertDialog(
                                  title: 'Alert!',
                                  content: 'Are you sure you want to logout?',
                                  positiveText: 'Proceed',
                                  negativeText: 'Cancel',
                                  onPositiveActionClick: () async {
                                    await RepositoryProvider.of<
                                            FirebaseAuthServices>(context)
                                        .logoutFirebase();
                                    await RepositoryProvider.of<
                                            FlutterSecureStorage>(context)
                                        .deleteAll();
                                    await RepositoryProvider.of<
                                            StreamingSharedPreferences>(context)
                                        .clear();
                                    Navigator.pop(dContext);
                                  },
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
