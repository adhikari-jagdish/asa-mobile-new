import 'dart:convert';

import 'package:asp_asia/assets/assets.dart';
import 'package:asp_asia/common_utils/custom_sized_box.dart';
import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:asp_asia/theme/custom_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../common_utils/view_utils/custom_cupertino_alert_dialog.dart';
import '../../../common_utils/view_utils/shared_preference_master.dart';
import '../../../routes/route_constants.dart';
import '../../../theme/custom_style.dart';
import '../../login/view/login.dart';
import 'edit_profile.dart';

class MoreTopProfileCard extends StatelessWidget {
  const MoreTopProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColor.color2a8dc8,
      elevation: 5,
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: PreferenceBuilder<String>(
          preference: RepositoryProvider.of<SharedPreferenceMaster>(context)
              .userProfile,
          builder: (context, userProfile) {
            var userDetails = {};
            if (userProfile.isNotEmpty) {
              userDetails = json.decode(userProfile) as Map<String, dynamic>;
            }
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: userDetails['image'] ?? '',
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.no_photography_outlined,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    (userDetails['name'] != null &&
                            userDetails['name'].toString().isNotEmpty)
                        ? userDetails['name']
                        : 'Guest User',
                    style: CustomStyle.whiteTextBold.copyWith(fontSize: 18.sp),
                  ),
                  subtitle: Text(
                    (userDetails['email'] != null &&
                            userDetails['email'].toString().isNotEmpty)
                        ? userDetails['email']
                        : 'xxxxx@gmail.com',
                    style:
                        CustomStyle.whiteTextSemiBold.copyWith(fontSize: 15.sp),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(35),
                    ),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            decoration: const BoxDecoration(
                              color: CustomColor.colorF58420,
                              shape: BoxShape.circle,
                            ),
                          ),
                          sboxW20,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Modify',
                                style: CustomStyle.blackTextSemiBold
                                    .copyWith(fontSize: 15.sp),
                              ),
                              Text(
                                'Tap to change your data',
                                style: CustomStyle.blackTextRegular
                                    .copyWith(fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      ),
                    ],
                  ).clickable(() async {
                    if (userDetails.isNotEmpty) {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: EditProfile(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    } else {
                      await showDialog(
                        context: context,
                        builder: (dContext) {
                          return CustomCupertinoAlertDialog(
                            title: 'Alert!',
                            content: 'Please signup/login to continue',
                            positiveText: 'Proceed',
                            negativeText: 'Cancel',
                            onPositiveActionClick: () {
                              Navigator.pop(dContext);
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: Login(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.fade,
                              );
                            },
                          );
                        },
                      );
                    }
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
