import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: SvgPicture.asset(
            'assets/images/icons/aspiration_asia_icon.svg',
            height: 100.h,
            width: 100.h,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
