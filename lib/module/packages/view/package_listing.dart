import 'package:asp_asia/common_utils/view_utils/no_data_available_widget.dart';
import 'package:asp_asia/module/destinations/model/destinations_model.dart';
import 'package:asp_asia/module/peakClimbing/cubit/peak_climbing_cubit.dart';
import 'package:asp_asia/theme/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sized_context/sized_context.dart';

import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/clickable_extension.dart';
import '../../../routes/route_constants.dart';
import '../../../theme/custom_style.dart';
import '../../adventure/cubit/adventure_cubit.dart';
import '../../expedition/cubit/expedition_cubit.dart';
import '../../tour/cubit/tour_cubit.dart';
import '../../trekking/cubit/trekking_cubit.dart';
import '../widget/package_listing_individual_design.dart';
import '../widget/package_top_image.dart';

class PackageListing extends StatelessWidget {
  PackageListing({
    Key? key,
    required this.destinationsModel,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();
  final DestinationsModel destinationsModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: PackageTopImage(
                    imageUrl: destinationsModel.image!,
                    title: destinationsModel.title!,
                  ),
                )
              ],
            ),
            sboxH20,
            BlocBuilder<TourCubit, TourState>(
              builder: (context, tourState) {
                if (tourState is TourSuccess) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CommonStrings.tour,
                              style: CustomStyle.blackTextSemiBold
                                  .copyWith(fontSize: 22.sp),
                            ),
                            (tourState.tourPackageList.isNotEmpty &&
                                    tourState.tourPackageList.length >= 4)
                                ? Text(
                                    CommonStrings.viewMore,
                                    style:
                                        CustomStyle.blackTextSemiBold.copyWith(
                                      fontSize: 15.sp,
                                      color: CustomColor.color2a8dc8,
                                    ),
                                  ).clickable(() {
                                    Navigator.pushNamed(context,
                                        RouteConstants.routePackageSearch,
                                        arguments: tourState.tourPackageList);
                                  })
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      sboxH10,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 315.h,
                        child: ListView.separated(
                          itemCount: tourState.tourPackageList.length > 5
                              ? 5
                              : tourState.tourPackageList.length,
                          controller: ScrollController(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return PackageListingIndividualDesign(
                              packageModel: tourState.tourPackageList[index],
                            ).clickable(() {
                              Navigator.pushNamed(
                                  context, RouteConstants.routePackageDetails,
                                  arguments: tourState.tourPackageList[index]);
                            });
                          },
                          separatorBuilder: (context, index) {
                            return sboxW20;
                          },
                        ),
                      ),
                    ],
                  );
                } else if (tourState is TourError) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          CommonStrings.tour,
                          style: CustomStyle.blackTextSemiBold
                              .copyWith(fontSize: 22.sp),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 215.h,
                        child: const NoDataAvailableWidget(
                            title: CommonStrings.tour),
                      ),
                    ],
                  );
                } else if (tourState is TourLoading) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 250.h,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListView.separated(
                        itemCount: 5,
                        controller: ScrollController(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.white,
                            width: context.widthPx / 2.1,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return sboxW20;
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            sboxH20,
            BlocBuilder<TrekkingCubit, TrekkingState>(
              builder: (context, trekkingState) {
                if (trekkingState is TrekkingSuccess) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CommonStrings.trekking,
                              style: CustomStyle.blackTextSemiBold
                                  .copyWith(fontSize: 22.sp),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                CommonStrings.viewMore,
                                style: CustomStyle.blackTextSemiBold.copyWith(
                                  fontSize: 15.sp,
                                  color: CustomColor.color2a8dc8,
                                ),
                              ),
                            ).clickable(() {
                              Navigator.pushNamed(
                                  context, RouteConstants.routePackageSearch,
                                  arguments: trekkingState.trekkingPackageList);
                            }),
                          ],
                        ),
                      ),
                      sboxH10,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 315.h,
                        child: ListView.separated(
                          itemCount:
                              trekkingState.trekkingPackageList.length > 5
                                  ? 5
                                  : trekkingState.trekkingPackageList.length,
                          controller: ScrollController(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return PackageListingIndividualDesign(
                              packageModel:
                                  trekkingState.trekkingPackageList[index],
                            ).clickable(() {
                              Navigator.pushNamed(
                                  context, RouteConstants.routePackageDetails,
                                  arguments:
                                      trekkingState.trekkingPackageList[index]);
                            });
                          },
                          separatorBuilder: (context, index) {
                            return sboxW20;
                          },
                        ),
                      ),
                    ],
                  );
                } else if (trekkingState is TrekkingLoading) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 250.h,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListView.separated(
                        itemCount: 5,
                        controller: ScrollController(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.white,
                            width: context.widthPx / 2.1,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return sboxW20;
                        },
                      ),
                    ),
                  );
                } else if (trekkingState is TrekkingError) {
                  return const SizedBox.shrink();
                }
                return const SizedBox.shrink();
              },
            ),
            BlocBuilder<ExpeditionCubit, ExpeditionState>(
              builder: (context, expeditionState) {
                if (expeditionState is ExpeditionSuccess) {
                  return Column(
                    children: [
                      sboxH20,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CommonStrings.expedition,
                              style: CustomStyle.blackTextSemiBold
                                  .copyWith(fontSize: 22.sp),
                            ),
                            Text(
                              CommonStrings.viewMore,
                              style: CustomStyle.blackTextSemiBold.copyWith(
                                fontSize: 15.sp,
                                color: CustomColor.color2a8dc8,
                              ),
                            ).clickable(() {
                              Navigator.pushNamed(
                                  context, RouteConstants.routePackageSearch,
                                  arguments:
                                      expeditionState.expeditionPackageList);
                            }),
                          ],
                        ),
                      ),
                      sboxH10,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 315.h,
                        child: ListView.separated(
                          itemCount:
                              expeditionState.expeditionPackageList.length > 5
                                  ? 5
                                  : expeditionState
                                      .expeditionPackageList.length,
                          controller: ScrollController(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return PackageListingIndividualDesign(
                              packageModel:
                                  expeditionState.expeditionPackageList[index],
                            ).clickable(() {
                              Navigator.pushNamed(
                                  context, RouteConstants.routePackageDetails,
                                  arguments: expeditionState
                                      .expeditionPackageList[index]);
                            });
                          },
                          separatorBuilder: (context, index) {
                            return sboxW20;
                          },
                        ),
                      ),
                    ],
                  );
                } else if (expeditionState is ExpeditionError) {
                  return const SizedBox.shrink();
                } else if (expeditionState is ExpeditionLoading) {
                  return Column(
                    children: [
                      sboxH20,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 250.h,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListView.separated(
                            itemCount: 5,
                            controller: ScrollController(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.white,
                                width: context.widthPx / 2.1,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return sboxW20;
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            BlocBuilder<PeakClimbingCubit, PeakClimbingState>(
              builder: (context, peakClimbingState) {
                if (peakClimbingState is PeakClimbingSuccess) {
                  return Column(
                    children: [
                      sboxH20,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CommonStrings.peakClimbing,
                              style: CustomStyle.blackTextSemiBold
                                  .copyWith(fontSize: 22.sp),
                            ),
                            Text(
                              CommonStrings.viewMore,
                              style: CustomStyle.blackTextSemiBold.copyWith(
                                fontSize: 15.sp,
                                color: CustomColor.color2a8dc8,
                              ),
                            ).clickable(() {
                              Navigator.pushNamed(
                                  context, RouteConstants.routePackageSearch,
                                  arguments:
                                      peakClimbingState.peakClimbingList);
                            }),
                          ],
                        ),
                      ),
                      sboxH10,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 315.h,
                        child: ListView.separated(
                          itemCount:
                              peakClimbingState.peakClimbingList.length > 5
                                  ? 5
                                  : peakClimbingState.peakClimbingList.length,
                          controller: ScrollController(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return PackageListingIndividualDesign(
                              packageModel:
                                  peakClimbingState.peakClimbingList[index],
                            ).clickable(() {
                              Navigator.pushNamed(
                                  context, RouteConstants.routePackageDetails,
                                  arguments: peakClimbingState
                                      .peakClimbingList[index]);
                            });
                          },
                          separatorBuilder: (context, index) {
                            return sboxW20;
                          },
                        ),
                      ),
                    ],
                  );
                } else if (peakClimbingState is PeakClimbingError) {
                  return const SizedBox.shrink();
                } else if (peakClimbingState is PeakClimbingLoading) {
                  return Column(
                    children: [
                      sboxH20,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 250.h,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListView.separated(
                            itemCount: 5,
                            controller: ScrollController(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.white,
                                width: context.widthPx / 2.1,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return sboxW20;
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            BlocBuilder<AdventureCubit, AdventureState>(
              builder: (context, adventureState) {
                if (adventureState is AdventureSuccess) {
                  return Column(
                    children: [
                      sboxH20,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CommonStrings.adventure,
                              style: CustomStyle.blackTextSemiBold
                                  .copyWith(fontSize: 22.sp),
                            ),
                            Text(
                              CommonStrings.viewMore,
                              style: CustomStyle.blackTextSemiBold.copyWith(
                                fontSize: 15.sp,
                                color: CustomColor.color2a8dc8,
                              ),
                            ).clickable(() {
                              Navigator.pushNamed(
                                  context, RouteConstants.routePackageSearch,
                                  arguments: adventureState.adventurePackages);
                            }),
                          ],
                        ),
                      ),
                      sboxH10,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 315.h,
                        child: ListView.separated(
                          itemCount: adventureState.adventurePackages.length > 5
                              ? 5
                              : adventureState.adventurePackages.length,
                          controller: ScrollController(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return PackageListingIndividualDesign(
                              packageModel:
                                  adventureState.adventurePackages[index],
                            ).clickable(() {
                              Navigator.pushNamed(
                                  context, RouteConstants.routePackageDetails,
                                  arguments:
                                      adventureState.adventurePackages[index]);
                            });
                          },
                          separatorBuilder: (context, index) {
                            return sboxW20;
                          },
                        ),
                      ),
                    ],
                  );
                } else if (adventureState is AdventureError) {
                  return const SizedBox.shrink();
                } else if (adventureState is AdventureLoading) {
                  return Column(
                    children: [
                      sboxH20,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 250.h,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListView.separated(
                            itemCount: 5,
                            controller: ScrollController(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.white,
                                width: context.widthPx / 2.1,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return sboxW20;
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            sboxH10,
          ],
        ),
      ),
    );
  }
}
