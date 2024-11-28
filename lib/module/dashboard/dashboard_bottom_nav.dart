import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../common_utils/system_util.dart';
import '../../theme/custom_color.dart';
import '../destinations/view/destinations.dart';
import '../inbox/view/inbox.dart';
import '../login/model/userModel.dart';
import '../more/view/more.dart';
import '../trips/view/trips.dart';
import 'home.dart';

class DashboardBottomNav extends StatefulWidget {
  const DashboardBottomNav({Key? key, this.userModel}) : super(key: key);
  final UserModel? userModel;

  @override
  State<DashboardBottomNav> createState() => _DashboardBottomNavState();
}

class _DashboardBottomNavState extends State<DashboardBottomNav> {
  PersistentTabController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemUtils().showSystemUiOverlay();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      // Default is Colors.white.
      handleAndroidBackButtonPress: true,
      // Default is true.
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true,
      // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),

      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
      ),
      navBarStyle:
          NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      const Home(),
      const Destinations(),
      const Trips(),
      const Inbox(),
      const More(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          FontAwesomeIcons.home,
          size: 20,
        ),
        title: ("Home"),
        activeColorPrimary: CustomColor.color2a8dc8.withOpacity(0.8),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          FontAwesomeIcons.globe,
          size: 20,
        ),
        title: ("Destinations"),
        activeColorPrimary: CustomColor.color2a8dc8.withOpacity(0.8),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          FontAwesomeIcons.tags,
          size: 20,
        ),
        title: ("Trips"),
        activeColorPrimary: CustomColor.colorF58420,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          FontAwesomeIcons.comments,
          size: 20,
        ),
        title: ("Inbox"),
        activeColorPrimary: CustomColor.color2a8dc8.withOpacity(0.8),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          FontAwesomeIcons.bars,
          size: 20,
        ),
        title: ("More"),
        activeColorPrimary: CustomColor.color2a8dc8.withOpacity(0.8),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
