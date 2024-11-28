import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_utils/custom_sized_box.dart';
import '../../../theme/custom_style.dart';

class LoginTopSection extends StatelessWidget {
  const LoginTopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CommonStrings.welcome,
          style: CustomStyle.blackTextBold.copyWith(fontSize: 25.sp),
        ),
        sboxH3,
        Text(
          CommonStrings.signInToContinue,
          style: CustomStyle.blackTextRegular.copyWith(
            color: Colors.grey,
            fontSize: 20.sp,
          ),
        ),
      ],
    );
  }
}
