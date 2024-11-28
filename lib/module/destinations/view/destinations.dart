import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sized_context/sized_context.dart';

import '../../../common_utils/common_strings.dart';
import '../../../common_utils/view_utils/clickable_extension.dart';
import '../../../common_utils/view_utils/utils.dart';
import '../../../theme/custom_style.dart';
import '../../adventure/cubit/adventure_cubit.dart';
import '../../expedition/cubit/expedition_cubit.dart';
import '../../packages/view/package_listing.dart';
import '../../peakClimbing/cubit/peak_climbing_cubit.dart';
import '../../tour/cubit/tour_cubit.dart';
import '../../trekking/cubit/trekking_cubit.dart';
import '../bloc/destinations_cubit.dart';
import '../model/destinations_model.dart';

class Destinations extends StatefulWidget {
  const Destinations({Key? key}) : super(key: key);

  @override
  State<Destinations> createState() => _DestinationsState();
}

class _DestinationsState extends State<Destinations> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DestinationsCubit>().getAllDestinations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                CommonStrings.travelIsNotAMatterOfMoney,
                style: CustomStyle.blackTextBold.copyWith(fontSize: 27.sp),
              ),
            ),
            Expanded(
              child: BlocBuilder<DestinationsCubit, DestinationsState>(
                builder: (context, destinationsState) {
                  if (destinationsState is DestinationsSuccess) {
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(10.0),
                      itemCount: destinationsState.destinationsList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          _buildIndividualItems(
                              destinationsState.destinationsList[index],
                              index,
                              context),
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 10.0,
                    );
                  } else if (destinationsState is DestinationsLoading) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(10.0),
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) =>
                            Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 10.0,
                      ),
                    );
                  } else if (destinationsState is DestinationsError) {
                    return Utils().commonErrorTextWidget(
                        context: context,
                        errorMessage: CommonStrings.destinationNotFound);
                  }
                  return const SizedBox.shrink();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildIndividualItems(
      DestinationsModel destinationsModel, int index, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
          image: CachedNetworkImageProvider(
            destinationsModel.image!,
            maxHeight: 600,
            maxWidth: 600,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10.0,
            bottom: 10.0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              width: context.widthPx / 2.5,
              child: Text(
                '${destinationsModel.title}',
                style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 22.sp),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            right: 10.0,
            top: 10.0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                CommonStrings.viewDetails,
                style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ).clickable(() {
      ///Call all packages by destination
      context.read<TrekkingCubit>().getTrekkingPackagesByDestinationId(
          destinationId: destinationsModel.id!);
      context.read<ExpeditionCubit>().getExpeditionPackagesByDestinationId(
          destinationId: destinationsModel.id!);
      context
          .read<TourCubit>()
          .getTourPackagesByDestinationId(destinationId: destinationsModel.id!);
      context.read<PeakClimbingCubit>().getPeakClimbingPackagesByDestinationId(
          destinationId: destinationsModel.id!);
      context.read<AdventureCubit>().getAdventurePackagesByDestinationId(
          destinationId: destinationsModel.id!);
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: PackageListing(destinationsModel: destinationsModel),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
    });
  }
}
