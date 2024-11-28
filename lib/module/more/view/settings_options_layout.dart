import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_utils/custom_sized_box.dart';
import '../../../theme/custom_style.dart';

class SettingsOptionsLayout extends StatelessWidget {
  SettingsOptionsLayout({
    Key? key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.onClicked,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final String subTitle;
  final VoidCallback? onClicked;

  final optionsMap = {
    'Legal Documents': 'Check out our registration documents',
    'Terms & Conditions': 'View our Terms & Conditions',
    'About': 'Learn more about Aspiration Asia',
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClicked,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                sboxW20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 15.sp),
                    ),
                    Text(
                      subTitle,
                      style: CustomStyle.blackTextRegular.copyWith(fontSize: 13.sp),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: Colors.grey.withOpacity(0.9),
            ),
          ],
        ),
      ),
    );
  }
}
