import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../assets/assets.dart';
import '../common_utils/view_utils/shared_preference_master.dart';
import '../routes/route_constants.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool isCurrencySelected =
        RepositoryProvider.of<SharedPreferenceMaster>(context)
            .isCurrencySelected
            .getValue();

    ///Check if preferred currency is selected or not, if selected go to dashboard else to selection screen.
    if (isCurrencySelected) {
      Future.delayed(
        const Duration(seconds: 6),
        () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteConstants.routeDashboardBottomNav,
            (route) {
              return false;
            },
          );
        },
      );
    } else {
      Future.delayed(
        const Duration(seconds: 6),
        () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteConstants.routeCurrencySelection,
            (route) {
              return false;
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Center(
        child: Image.asset(
          Assets.aspirationAsiaGifIcon,
          fit: BoxFit.contain,
          width: 180.w,
          height: 180.h,
        ),
      ),
    );
  }
}
