import 'package:asp_asia/common_utils/custom_functions.dart';
import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:asp_asia/common_utils/view_utils/shared_preference_master.dart';
import 'package:asp_asia/module/packages/view/package_details.dart';
import 'package:asp_asia/theme/custom_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/utils.dart';
import '../../../theme/custom_style.dart';
import '../cubit/popularPackages/popular_packages_cubit.dart';

class HomePopularPackages extends StatefulWidget {
  const HomePopularPackages({Key? key}) : super(key: key);

  @override
  State<HomePopularPackages> createState() => _HomePopularPackagesState();
}

class _HomePopularPackagesState extends State<HomePopularPackages> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PopularPackagesCubit>().getAllPopularPackages();
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
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Text(
            CommonStrings.popularPackages,
            style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 18.sp),
          ),
        ),
        sboxH5,
        MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: BlocBuilder<PopularPackagesCubit, PopularPackagesState>(
            builder: (context, popularPackagesState) {
              if (popularPackagesState is PopularPackagesSuccess) {
                return ListView.separated(
                  itemCount: popularPackagesState.popularPackages.length > 5
                      ? 5
                      : popularPackagesState.popularPackages.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: ScrollController(),
                  itemBuilder: (context, index) {
                    final packageModel =
                        popularPackagesState.popularPackages[index];
                    rateIndexByHotelCategory =
                        CustomFunctions().getIndexByHotelCategory(packageModel);
                    int? packageRate = CustomFunctions()
                        .packageRateAccordingToCurrencyAndHotelCategory(
                            packageModel,
                            rateIndexByHotelCategory,
                            selectedCurrency);

                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: CachedNetworkImage(
                          imageUrl: packageModel.image != null
                              ? packageModel.image!
                              : '',
                          width: 90.w,
                          height: 90.h,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.no_photography_outlined,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        packageModel.title!,
                        style: CustomStyle.blackTextSemiBold
                            .copyWith(fontSize: 15.sp),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sboxH3,
                          Text(
                            '${packageModel.duration} Days',
                            style: CustomStyle.blackTextRegular
                                .copyWith(fontSize: 13.sp),
                          ),
                        ],
                      ),
                      trailing: Column(
                        children: [
                          Text(
                            '$selectedCurrency $packageRate',
                            style: CustomStyle.blackTextSemiBold.copyWith(
                                fontSize: 12.sp,
                                decoration: TextDecoration.lineThrough),
                          ),
                          sboxH3,
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              '$selectedCurrency $packageRate',
                              style: CustomStyle.whiteTextSemiBold
                                  .copyWith(fontSize: 13.sp),
                            ),
                            decoration: BoxDecoration(
                                color: CustomColor.colorF58420,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ],
                      ),
                    ).clickable(() {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: PackageDetails(
                            packageModel:
                                popularPackagesState.popularPackages[index]),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    });
                  },
                  separatorBuilder: (context, index) {
                    return sboxH10;
                  },
                );
              } else if (popularPackagesState is PopularPackagesLoading) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                    itemCount: 6,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Card(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: SizedBox(height: 80.h),
                        ),
                      );
                    },
                  ),
                );
              } else if (popularPackagesState is PopularPackagesError) {
                return Utils().commonErrorTextWidget(
                    context: context,
                    errorMessage: CommonStrings.popularPackagesNotFound);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget loadingAnimationWidget() {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 90.w,
          height: 90.h,
          color: Colors.white,
        ),
      ),
      title: Container(
        height: 10.h,
        width: 70.w,
        color: Colors.white,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sboxH3,
          Container(
            height: 10.h,
            width: 50.w,
            color: Colors.white,
          ),
        ],
      ),
      trailing: Column(
        children: [
          Container(
            height: 10.h,
            width: 50.w,
            color: Colors.white,
          ),
          sboxH3,
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
          ),
        ],
      ),
    );
  }
}
