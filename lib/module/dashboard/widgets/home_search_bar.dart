import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:asp_asia/module/login/model/userModel.dart';
import 'package:asp_asia/theme/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/custom_style.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({Key? key, this.userModel}) : super(key: key);

  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: CommonStrings.whatWouldYouLikeToBook,
          hintStyle: CustomStyle.blackTextMedium.copyWith(
            fontSize: 12.sp,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(
            Icons.search,
          ),
          enabled: false,
        ),
      ),
    );
  }
}
