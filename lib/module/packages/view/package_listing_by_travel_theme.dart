import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/no_data_available_widget.dart';
import '../../../common_utils/view_utils/package_listing_individual_for_shimmer.dart';
import '../../../routes/route_constants.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../../adventure/cubit/adventure_cubit.dart';
import '../../dashboard/model/packages_by_theme_model.dart';
import '../../expedition/cubit/expedition_cubit.dart';
import '../../tour/cubit/tour_cubit.dart';
import '../../trekking/cubit/trekking_cubit.dart';
import '../widget/package_listing_individual_design.dart';
import '../widget/package_top_image.dart';

class PackageListingByTravelTheme extends StatefulWidget {
  const PackageListingByTravelTheme(
      {Key? key, required this.packagesByThemeModel})
      : super(key: key);

  final PackagesByThemeModel packagesByThemeModel;

  @override
  State<PackageListingByTravelTheme> createState() =>
      _PackageListingByTravelThemeState();
}

class _PackageListingByTravelThemeState
    extends State<PackageListingByTravelTheme> {
  final ScrollController scrollController = ScrollController();

  final sampleNumbers = [1, 2, 3, 4, 5, 6, 7, 8];

  @override
  void initState() {
    context.read<TrekkingCubit>().getTrekkingPackagesByTravelThemeId(
        travelThemeId: widget.packagesByThemeModel.id ?? '');
    context.read<ExpeditionCubit>().getExpeditionPackagesByTravelThemeId(
        travelThemeId: widget.packagesByThemeModel.id ?? '');
    context.read<TourCubit>().getTourPackagesByTravelThemeId(
        travelThemeId: widget.packagesByThemeModel.id ?? '');
    context.read<AdventureCubit>().getAdventurePackagesByTravelThemeId(
        travelThemeId: widget.packagesByThemeModel.id ?? '');
    super.initState();
  }

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
                    imageUrl: widget.packagesByThemeModel.image!,
                    title: widget.packagesByThemeModel.title!,
                  ),
                )
              ],
            ),
            BlocBuilder<TrekkingCubit, TrekkingState>(
              builder: (context, trekkingState) {
                if (trekkingState is TrekkingSuccess) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: LayoutGrid(
                      columnGap: 4,
                      rowGap: 4,
                      columnSizes: [1.fr, 1.fr],
                      rowSizes: List<IntrinsicContentTrackSize>.generate(
                          (trekkingState.trekkingPackageList.length / 2)
                              .round(),
                          (int index) => auto),
                      children: List<Widget>.generate(
                        trekkingState.trekkingPackageList.length,
                        (int index) => PackageListingIndividualDesign(
                          packageModel:
                              trekkingState.trekkingPackageList[index],
                        ).clickable(() {
                          Navigator.pushNamed(
                              context, RouteConstants.routePackageDetails,
                              arguments:
                                  trekkingState.trekkingPackageList[index]);
                        }),
                      ),
                    ),
                  );
                } else if (trekkingState is TrekkingLoading) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 8,
                        runSpacing: 10,
                        direction: Axis.horizontal,
                        children: sampleNumbers.map((e) {
                          return const PackageListingIndividualForShimmer();
                        }).toList(),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            BlocBuilder<ExpeditionCubit, ExpeditionState>(
              builder: (context, expeditionState) {
                if (expeditionState is ExpeditionSuccess) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: LayoutGrid(
                      columnGap: 4,
                      rowGap: 4,
                      columnSizes: [1.fr, 1.fr],
                      rowSizes: List<IntrinsicContentTrackSize>.generate(
                          (expeditionState.expeditionPackageList.length / 2)
                              .round(),
                          (int index) => auto),
                      children: List<Widget>.generate(
                        expeditionState.expeditionPackageList.length,
                        (int index) => PackageListingIndividualDesign(
                          packageModel:
                              expeditionState.expeditionPackageList[index],
                        ).clickable(() {
                          Navigator.pushNamed(
                              context, RouteConstants.routePackageDetails,
                              arguments:
                                  expeditionState.expeditionPackageList[index]);
                        }),
                      ),
                    ),
                  );
                } else if (expeditionState is ExpeditionLoading) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 8,
                        runSpacing: 10,
                        direction: Axis.horizontal,
                        children: sampleNumbers.map((e) {
                          return const PackageListingIndividualForShimmer();
                        }).toList(),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            sboxH20,
            BlocBuilder<TourCubit, TourState>(
              builder: (context, tourState) {
                if (tourState is TourSuccess) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: LayoutGrid(
                      columnGap: 4,
                      rowGap: 4,
                      columnSizes: [1.fr, 1.fr],
                      rowSizes: List<IntrinsicContentTrackSize>.generate(
                          (tourState.tourPackageList.length / 2).round(),
                          (int index) => auto),
                      children: List<Widget>.generate(
                        tourState.tourPackageList.length,
                        (int index) => PackageListingIndividualDesign(
                          packageModel: tourState.tourPackageList[index],
                        ).clickable(() {
                          Navigator.pushNamed(
                              context, RouteConstants.routePackageDetails,
                              arguments: tourState.tourPackageList[index]);
                        }),
                      ),
                    ),
                  );
                } else if (tourState is TourLoading) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 8,
                        runSpacing: 10,
                        direction: Axis.horizontal,
                        children: sampleNumbers.map((e) {
                          return const PackageListingIndividualForShimmer();
                        }).toList(),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            sboxH20,
            BlocBuilder<AdventureCubit, AdventureState>(
              builder: (context, adventureState) {
                if (adventureState is AdventureSuccess) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: LayoutGrid(
                      columnGap: 4,
                      rowGap: 4,
                      columnSizes: [1.fr, 1.fr],
                      rowSizes: List<IntrinsicContentTrackSize>.generate(
                          (adventureState.adventurePackages.length / 2).round(),
                          (int index) => auto),
                      children: List<Widget>.generate(
                        adventureState.adventurePackages.length,
                        (int index) => PackageListingIndividualDesign(
                          packageModel: adventureState.adventurePackages[index],
                        ).clickable(() {
                          Navigator.pushNamed(
                              context, RouteConstants.routePackageDetails,
                              arguments:
                                  adventureState.adventurePackages[index]);
                        }),
                      ),
                    ),
                  );
                } else if (adventureState is TourLoading) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 8,
                        runSpacing: 10,
                        direction: Axis.horizontal,
                        children: sampleNumbers.map((e) {
                          return const PackageListingIndividualForShimmer();
                        }).toList(),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
