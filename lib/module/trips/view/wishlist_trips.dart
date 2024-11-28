import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:asp_asia/module/login/view/login.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class WishlistTrips extends StatelessWidget {
  const WishlistTrips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text(CommonStrings.comingSoon).clickable(() {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: Login(),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      }),
    );
  }
}
