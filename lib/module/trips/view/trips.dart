import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sized_context/sized_context.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/shared_preference_master.dart';
import '../../../enum/booking_status_enum.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../../login/view/login.dart';
import '../model/booking_response_model.dart';
import '../service/booking_api_service.dart';
import 'completed_trips.dart';
import 'upcoming_trips.dart';
import 'wishlist_trips.dart';

class Trips extends StatefulWidget {
  const Trips({Key? key}) : super(key: key);

  @override
  State<Trips> createState() => _TripsState();
}

class _TripsState extends State<Trips> with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            CommonStrings.trips,
            style: CustomStyle.blackTextBold.copyWith(fontSize: 27.sp),
          ),
          bottom: TabBar(
            controller: _controller,
            tabs: [
              Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  'Upcoming',
                  style:
                      CustomStyle.blackTextSemiBold.copyWith(fontSize: 14.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  'Completed',
                  style:
                      CustomStyle.blackTextSemiBold.copyWith(fontSize: 14.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  'Wishlist',
                  style:
                      CustomStyle.blackTextSemiBold.copyWith(fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: PreferenceBuilder<String>(
              preference: RepositoryProvider.of<SharedPreferenceMaster>(context)
                  .userProfile,
              builder: (context, userProfile) {
                String userId = "";
                if (userProfile.isNotEmpty) {
                  final userDetails =
                      json.decode(userProfile) as Map<String, dynamic>;
                  if (userDetails["userId"] != null) {
                    userId = userDetails["userId"];
                  }
                }
                if (userId.isNotEmpty) {
                  return StreamBuilder(
                      stream: RepositoryProvider.of<BookingApiService>(context)
                          .getBookingStream(userId: userId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List parsed =
                              json.decode(snapshot.data as String);
                          final bookingsData =
                              parsed.cast<Map<String, dynamic>>().map((e) {
                            return BookingResponseModel.fromJson(e);
                          });
                          final bookings =
                              List<BookingResponseModel>.from(bookingsData);

                          final filteredBookingsExceptCompleted =
                              bookings.where((element) {
                            if (element.status != null &&
                                element.tripStartDate != null) {
                              if (element.status !=
                                      BookingStatusEnum
                                          .bookingCompleted.index &&
                                  element.tripStartDate!
                                      .isAfter(DateTime.now())) {
                                return true;
                              }
                            }
                            return false;
                          }).toList();
                          final filteredCompleted = bookings
                              .where((element) =>
                                  element.status ==
                                  BookingStatusEnum.bookingCompleted.index)
                              .toList();
                          return TabBarView(
                            controller: _controller,
                            children: [
                              UpcomingTrips(
                                  bookings: filteredBookingsExceptCompleted),
                              CompletedTrips(bookings: filteredCompleted),
                              const WishlistTrips(),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return TabBarView(
                            controller: _controller,
                            children: [
                              const UpcomingTrips(bookings: []),
                              CompletedTrips(bookings: []),
                              const WishlistTrips(),
                            ],
                          );
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListView.builder(
                            itemCount: 6,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    EdgeInsets.only(left: 10.w, right: 10.w),
                                child: Card(
                                  elevation: 1.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: SizedBox(height: 150.h),
                                ),
                              );
                            },
                          ),
                        );
                      });
                } else {
                  return SizedBox(
                    height: context.heightPx / 1.5,
                    width: context.widthPx,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          CommonStrings.loginSignupToViewTrips,
                          style: CustomStyle.blackTextMedium
                              .copyWith(fontSize: 13.sp),
                        ),
                        sboxH10,
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.only(left: 30.0, right: 30.0),
                            side: const BorderSide(
                                color: CustomColor.color2a8dc8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: Login(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.scale,
                            );
                          },
                          child: Text(
                            CommonStrings.proceed,
                            style: CustomStyle.blackTextMedium
                                .copyWith(fontSize: 13.sp),
                          ),
                        )
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
