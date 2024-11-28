import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_functions.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/shared_preference_master.dart';
import '../../../common_utils/view_utils/utils.dart';
import '../../../theme/custom_style.dart';
import '../../packages/view/package_details.dart';
import '../cubit/recommendedPackages/recommended_package_cubit.dart';

class HomeRecommended extends StatefulWidget {
  const HomeRecommended({Key? key}) : super(key: key);

  @override
  State<HomeRecommended> createState() => _HomeRecommendedState();
}

class _HomeRecommendedState extends State<HomeRecommended> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<RecommendedPackageCubit>().getAllRecommendedPackages();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCurrency =
        RepositoryProvider.of<SharedPreferenceMaster>(context)
            .currencySelected
            .getValue();
    int rateIndexByHotelCategory = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CommonStrings.recommendedTours,
          style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 18.sp),
        ),
        sboxH10,
        BlocBuilder<RecommendedPackageCubit, RecommendedPackageState>(
          builder: (context, recommendedPackageState) {
            if (recommendedPackageState is RecommendedPackageSuccess) {
              return SizedBox(
                height: 200.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final recommendedPackage =
                        recommendedPackageState.recommendedPackages[index];
                    rateIndexByHotelCategory = CustomFunctions()
                        .getIndexByHotelCategory(recommendedPackage);
                    int? packageRate = CustomFunctions()
                        .packageRateAccordingToCurrencyAndHotelCategory(
                            recommendedPackage,
                            rateIndexByHotelCategory,
                            selectedCurrency);
                    return Stack(
                      children: [
                        Container(
                          width: 170.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                recommendedPackage.image ?? '',
                                maxHeight: 400,
                                maxWidth: 500,
                                errorListener: (listener) => const Center(
                                  child: Icon(
                                    Icons.no_photography_outlined,
                                    size: 40,
                                    color: Colors.black12,
                                  ),
                                ),
                              ),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.darken),
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                            color: recommendedPackage.image != null
                                ? recommendedPackage.image!.isNotEmpty
                                    ? Colors.white
                                    : Colors.grey[500]
                                : Colors.grey[500],
                          ),
                        ),
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              '$selectedCurrency $packageRate',
                              style: CustomStyle.whiteTextSemiBold
                                  .copyWith(fontSize: 13.sp),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          top: 10.h,
                          right: 10.w,
                        ),
                        Positioned(
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  recommendedPackage.title!,
                                  style: CustomStyle.whiteTextSemiBold
                                      .copyWith(fontSize: 13.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                sboxH5,
                                Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.clock,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    sboxW5,
                                    Text(
                                      '${recommendedPackage.duration} Days',
                                      style: CustomStyle.whiteTextMedium
                                          .copyWith(fontSize: 13.sp),
                                    ),
                                  ],
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: const EdgeInsets.all(10),
                            width: 150.w,
                          ),
                          bottom: 10.h,
                          left: 10.w,
                        )
                      ],
                    ).clickable(() {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen:
                            PackageDetails(packageModel: recommendedPackage),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    });
                  },
                  separatorBuilder: (context, index) => sboxW10,
                  itemCount: recommendedPackageState.recommendedPackages.length,
                ),
              );
            } else if (recommendedPackageState is RecommendedPackageLoading) {
              return SizedBox(
                height: 200.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 170.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.white),
                    );
                  },
                  separatorBuilder: (context, index) => sboxW10,
                ),
              );
            } else if (recommendedPackageState is RecommendedPackageError) {
              return Utils().commonErrorTextWidget(
                  context: context,
                  errorMessage: CommonStrings.recommendedToursNotFound);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
