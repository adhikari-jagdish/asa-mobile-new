import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../view/package_details_view_more_screen.dart';

class PackageDetailsExclusions extends StatelessWidget {
  const PackageDetailsExclusions({
    Key? key,
    required this.exclusions,
  }) : super(key: key);

  final List<String> exclusions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            CommonStrings.exclusions,
            style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 18.sp),
          ),
        ),
        sboxH20,
        MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return RichText(
                  text: TextSpan(
                    text: 'x ',
                    style: CustomStyle.blackTextSemiBold.copyWith(
                      fontSize: 18.sp,
                      color: CustomColor.colorF58420,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' ${exclusions[index]}',
                        style: CustomStyle.blackTextMedium.copyWith(fontSize: 15.sp),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => sboxH20,
              itemCount: exclusions.length <= 3 ? exclusions.length : 3,
            ),
          ),
        ),
        exclusions.length > 3
            ? Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Read More ",
                  style: CustomStyle.blackTextSemiBold.copyWith(color: CustomColor.color2a8dc8, fontSize: 12.sp),
                ),
                const WidgetSpan(
                  child: Icon(Icons.arrow_drop_down_outlined, size: 14),
                ),
              ],
            ),
          ).clickable(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PackageDetailsViewMoreScreen(
                  title: CommonStrings.exclusions,
                  exclusions: exclusions,
                ),
              ),
            );
          }),
        )
            : const SizedBox.shrink()
      ],
    );
  }
}
