import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/custom_color.dart';
import '../../theme/custom_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.buttonText}) : super(key: key);

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: CustomColor.color2a8dc8,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      width: MediaQuery.of(context).size.width / 2,
      height: 50.h,
      child: Center(
        child: Text(
          buttonText,
          style: CustomStyle.whiteTextSemiBold,
        ),
      ),
    );
  }
}
