import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_utils/custom_sized_box.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../model/itinerary_model.dart';
import '../widget/package_details_itinerary.dart';

class PackageDetailsViewMoreScreen extends StatelessWidget {
  const PackageDetailsViewMoreScreen({
    Key? key,
    required this.title,
    this.overview,
    this.itineraries,
    this.inclusions,
    this.exclusions,
  }) : super(key: key);

  final String title;
  final String? overview;
  final List<ItineraryModel>? itineraries;
  final List<String>? inclusions;
  final List<String>? exclusions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: CustomStyle.blackTextSemiBold,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ).clickable(() {
          Navigator.of(context).pop();
        }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            overview != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      overview!,
                      style: CustomStyle.blackTextRegular.copyWith(fontSize: 15.sp),
                      textAlign: TextAlign.justify,
                    ),
                  )
                : const SizedBox.shrink(),
            itineraries != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ItineraryTitles(
                      itineraries: itineraries!,
                      shouldShowAll: true,
                    ),
                  )
                : const SizedBox.shrink(),
            inclusions != null
                ? MediaQuery.removePadding(
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
                              text: '+ ',
                              style: CustomStyle.blackTextSemiBold.copyWith(
                                fontSize: 18.sp,
                                color: CustomColor.color2a8dc8,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' ${inclusions![index]}',
                                  style: CustomStyle.blackTextMedium.copyWith(fontSize: 15.sp),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => sboxH20,
                        itemCount: inclusions!.length,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            exclusions != null
                ? MediaQuery.removePadding(
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
                                  text: ' ${exclusions![index]}',
                                  style: CustomStyle.blackTextMedium.copyWith(fontSize: 15.sp),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => sboxH20,
                        itemCount: exclusions!.length,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
