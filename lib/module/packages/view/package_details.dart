import 'dart:convert';

import 'package:asp_asia/common_utils/custom_functions.dart';
import 'package:asp_asia/common_utils/view_utils/utils.dart';
import 'package:asp_asia/routes/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sized_context/sized_context.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/clickable_extension.dart';
import '../../../common_utils/view_utils/custom_button.dart';
import '../../../common_utils/view_utils/custom_cupertino_alert_dialog.dart';
import '../../../common_utils/view_utils/hotel_star_rating_dialog_with_single_selection.dart';
import '../../../common_utils/view_utils/month_of_travel_dialog_with_single_selection.dart';
import '../../../common_utils/view_utils/shared_preference_master.dart';
import '../../tripCustomization/trip_customization.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../bloc/hotel_star_rating_toggle_cubit.dart';
import '../bloc/month_of_travel_toggle_cubit.dart';
import '../bloc/package_details_top_image_height_toggle_cubit.dart';
import '../model/package_model.dart';
import '../widget/package_details_accommodation.dart';
import '../widget/package_details_exclusions.dart';
import '../widget/package_details_inclusions.dart';
import '../widget/package_details_itinerary.dart';
import '../widget/package_details_top_section.dart';
import '../widget/package_price_inclusive_of.dart';
import 'package_details_view_more_screen.dart';

class PackageDetails extends StatefulWidget {
  const PackageDetails({Key? key, required this.packageModel})
      : super(key: key);

  final PackageModel packageModel;

  @override
  State<PackageDetails> createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  List<String> hotelCategoryList = [];
  List<String> monthsOfTravel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.packageModel.packageRate != null &&
        widget.packageModel.packageRate!.isNotEmpty) {
      for (var hotel in widget.packageModel.packageRate!) {
        if (hotel.hotelCategory != null) {
          hotelCategoryList.add(hotel.hotelCategory!);
        }
      }
      if (hotelCategoryList.isNotEmpty) {
        context.read<HotelStarRatingToggleCubit>().emit(
            HotelStarRatingToggleModelForCubit(
                hotelStarRating: hotelCategoryList[0], index: 0));
      }
    }
    monthsOfTravel =
        Utils().getMonthAYearFromCurrent(18, createdDate: DateTime.now());
    if (monthsOfTravel.isNotEmpty) {
      context.read<MonthOfTravelToggleCubit>().emit(
          MonthOfTravelToggleModelForCubit(
              index: 0, monthOfTravel: monthsOfTravel[0]));
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCurrency =
        RepositoryProvider.of<SharedPreferenceMaster>(context)
            .currencySelected
            .getValue();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.arrow_back,
          color:
              widget.packageModel.image != null ? Colors.white : Colors.black,
        ).clickable(() {
          Navigator.of(context).pop();
        }),
      ),
      bottomSheet: PreferenceBuilder<String>(
          preference: RepositoryProvider.of<SharedPreferenceMaster>(context)
              .userProfile,
          builder: (context, userProfile) {
            String uId = '';
            if (userProfile.isNotEmpty) {
              final profileDetails =
                  jsonDecode(userProfile) as Map<String, dynamic>;
              uId = profileDetails['userId'];
              if (uId.isNotEmpty) {}
            }
            return Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: const CustomButton(
                buttonText: CommonStrings.customizeAndGetQuote,
              ).clickable(() async {
                if (uId.isNotEmpty) {
                  Navigator.pushNamed(
                      context, RouteConstants.routeTripCustomization,
                      arguments: widget.packageModel);
                } else {
                  await showDialog(
                    context: context,
                    builder: (dContext) {
                      return CustomCupertinoAlertDialog(
                        title: 'Alert!',
                        content: 'Please signup/login to continue',
                        positiveText: 'Proceed',
                        negativeText: 'Cancel',
                        onPositiveActionClick: () {
                          Navigator.pop(dContext);
                          Navigator.pushNamed(
                              context, RouteConstants.routeLogin);
                        },
                      );
                    },
                  );
                }
              }),
            );
          }),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 80.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: PackageDetailsTopSection(
                          packageModel: widget.packageModel,
                        ),
                      )
                    ],
                  ),
                  (widget.packageModel.durationType == null)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                          child: Text(
                            'Per Person on Twin/Double Sharing',
                            style: CustomStyle.blackTextSemiBold
                                .copyWith(fontSize: 14.sp),
                            textAlign: TextAlign.justify,
                          ),
                        )
                      : sboxH20,
                  (widget.packageModel.packageRate != null &&
                          widget.packageModel.packageRate!.isNotEmpty)
                      ? (widget.packageModel.packageRate![0].hotelCategory !=
                              null)
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Wrap(
                                    children: const [
                                      FractionallySizedBox(
                                        widthFactor: 0.48,
                                        child: Text(
                                          'Hotel Star Rating',
                                          style: CustomStyle.blackTextSemiBold,
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: 0.05,
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: 0.47,
                                        child: Text(
                                          'Month Of Travel',
                                          style: CustomStyle.blackTextSemiBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                sboxH8,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Wrap(
                                    children: [
                                      FractionallySizedBox(
                                        widthFactor: 0.48,
                                        child: hotelCategoryList.isNotEmpty
                                            ? BlocBuilder<
                                                HotelStarRatingToggleCubit,
                                                HotelStarRatingToggleModelForCubit>(
                                                builder:
                                                    (context, hotelStarState) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(hotelStarState
                                                                .hotelStarRating ??
                                                            ''),
                                                        const Icon(Icons
                                                            .arrow_drop_down_outlined),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ).clickable(
                                                () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      content:
                                                          HotelStarRatingDialogWithSingleSelection(
                                                        hotelStarOptions:
                                                            hotelCategoryList,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                      const FractionallySizedBox(
                                        widthFactor: 0.05,
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: 0.47,
                                        child: BlocBuilder<
                                            MonthOfTravelToggleCubit,
                                            MonthOfTravelToggleModelForCubit>(
                                          builder: (context,
                                              monthOfTravelToggleModel) {
                                            return Container(
                                              alignment: Alignment.centerRight,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              padding: const EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(monthOfTravelToggleModel
                                                          .monthOfTravel ??
                                                      ''),
                                                  const Icon(Icons
                                                      .arrow_drop_down_outlined),
                                                ],
                                              ),
                                            );
                                          },
                                        ).clickable(() {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content:
                                                  MonthOfTravelDialogWithSingleSelection(
                                                monthOfTravelOptions: Utils()
                                                    .getMonthAYearFromCurrent(
                                                  18,
                                                  createdDate: DateTime.now(),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink()
                      : const SizedBox.shrink(),
                  sboxH20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      CommonStrings.overview,
                      style: CustomStyle.blackTextSemiBold
                          .copyWith(fontSize: 18.sp),
                    ),
                  ),
                  sboxH5,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.packageModel.overview!,
                      style: CustomStyle.blackTextRegular
                          .copyWith(fontSize: 15.sp),
                      textAlign: TextAlign.justify,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  (widget.packageModel.overview != null &&
                          widget.packageModel.overview!.length > 70)
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Read More ",
                                  style: CustomStyle.blackTextSemiBold.copyWith(
                                      color: CustomColor.color2a8dc8,
                                      fontSize: 12.sp),
                                ),
                                const WidgetSpan(
                                  child: Icon(Icons.arrow_drop_down_outlined,
                                      size: 14),
                                ),
                              ],
                            ),
                          ).clickable(
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PackageDetailsViewMoreScreen(
                                    title: CommonStrings.overview,
                                    overview: widget.packageModel.overview,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                  sboxH20,
                  widget.packageModel.packageInclusions != null
                      ? PackagePriceInclusiveOf(
                          packageInclusions:
                              widget.packageModel.packageInclusions!)
                      : const SizedBox.shrink(),
                  widget.packageModel.packageInclusions != null
                      ? sboxH20
                      : const SizedBox.shrink(),
                  widget.packageModel.itinerary != null
                      ? PackageDetailsItinerary(
                          itineraries: widget.packageModel.itinerary!)
                      : const SizedBox.shrink(),
                  sboxH20,
                  PackageDetailsInclusions(
                      inclusions: widget.packageModel.inclusions ?? []),
                  sboxH40,
                  PackageDetailsExclusions(
                      exclusions: widget.packageModel.exclusions ?? []),
                  sboxH40,
                  widget.packageModel.hotels != null
                      ? PackageDetailsAccommodation(
                          hotels: widget.packageModel.hotels!)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            BlocBuilder<PackageDetailsTopImageHeightToggleCubit, double>(
              builder: (context, state) {
                return Positioned(
                  top: state - 25.h,
                  child: Material(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(30)),
                    elevation: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      height: 45.h,
                      alignment: Alignment.centerLeft,
                      width: context.widthPx / 1.5,
                      child: Wrap(
                        children: [
                          BlocBuilder<HotelStarRatingToggleCubit,
                              HotelStarRatingToggleModelForCubit>(
                            builder: (context, hotelStarRatingModel) {
                              if (widget.packageModel.packageRate != null &&
                                  widget.packageModel.packageRate!.isNotEmpty) {
                                if (widget.packageModel.packageRate!.any(
                                    (element) => (element.hotelCategory !=
                                            null &&
                                        element.hotelCategory!.isNotEmpty))) {
                                  var rate = widget.packageModel.packageRate!
                                      .where((element) =>
                                          element.hotelCategory ==
                                          hotelStarRatingModel.hotelStarRating)
                                      .toList();
                                  int? packageRate = CustomFunctions()
                                      .packageRateAccordingToCurrency(
                                          rate[0], selectedCurrency);
                                  return Text(
                                    '$selectedCurrency ${rate.isNotEmpty ? packageRate : ''}',
                                    style: CustomStyle.whiteTextSemiBold
                                        .copyWith(fontSize: 20.sp),
                                  );
                                } else {
                                  return Text(
                                    '$selectedCurrency ${(widget.packageModel.packageRate != null && widget.packageModel.packageRate!.isNotEmpty) ? CustomFunctions().packageRateAccordingToCurrency(widget.packageModel.packageRate![0], selectedCurrency) : ''
                                        ''}',
                                    style: CustomStyle.whiteTextSemiBold
                                        .copyWith(fontSize: 20.sp),
                                  );
                                }
                              }
                              return Text(
                                '$selectedCurrency 0',
                                style: CustomStyle.whiteTextSemiBold
                                    .copyWith(fontSize: 20.sp),
                              );
                            },
                          ),
                          const FractionallySizedBox(
                            widthFactor: 0.05,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: widget.packageModel.durationType == null
                                ? Text(
                                    '(${widget.packageModel.duration! - 1}N/${widget.packageModel.duration}D)',
                                    style: CustomStyle.whiteTextSemiBold
                                        .copyWith(fontSize: 17.sp),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    '(${widget.packageModel.duration!} ${widget.packageModel.durationType})',
                                    style: CustomStyle.whiteTextSemiBold
                                        .copyWith(fontSize: 17.sp),
                                    textAlign: TextAlign.center,
                                  ),
                          )
                        ],
                      ),
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(30)),
                        color: CustomColor.color2a8dc8,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
