import 'package:asp_asia/common_utils/custom_sized_box.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common_utils/common_strings.dart';
import '../../../theme/custom_style.dart';
import '../model/package_inclusions_model.dart';

class PackagePriceInclusiveOf extends StatelessWidget {
  const PackagePriceInclusiveOf({Key? key, required this.packageInclusions}) : super(key: key);

  final List<PackageInclusionsModel> packageInclusions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 60.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              SvgPicture.network(
                packageInclusions[index].image!,
                width: 30,
                height: 30,
              ),
              sboxH5,
              Text(
                '${packageInclusions[index].title}',
                style: CustomStyle.blackTextMedium.copyWith(fontSize: 13.sp),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => sboxW30,
        itemCount: packageInclusions.length,
      ),
    );
  }
}
