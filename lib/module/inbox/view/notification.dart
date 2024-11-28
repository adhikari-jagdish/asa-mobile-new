import 'dart:convert';

import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:asp_asia/enum/booking_status_enum.dart';
import 'package:asp_asia/module/trips/service/booking_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sized_context/sized_context.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../assets/assets.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/app_loader.dart';
import '../../../common_utils/view_utils/shared_preference_master.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../../login/view/login.dart';
import '../model/notification_model.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PreferenceBuilder<String>(
            preference: RepositoryProvider.of<SharedPreferenceMaster>(context)
                .userProfile,
            builder: (context, userProfile) {
              String userId = "";
              if (userProfile.isNotEmpty) {
                final profileDetails =
                    jsonDecode(userProfile) as Map<String, dynamic>;
                userId = profileDetails['userId'];
                return StreamBuilder(
                    stream: RepositoryProvider.of<BookingApiService>(context)
                        .getNotificationsForUser(userId: userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List parsed =
                            json.decode(snapshot.data as String);
                        final notificationsData =
                            parsed.cast<Map<String, dynamic>>().map((e) {
                          return NotificationModel.fromJson(e);
                        });
                        final notifications =
                            List<NotificationModel>.from(notificationsData);
                        if (notifications.isNotEmpty) {
                          notifications.sort(
                              (a, b) => b.updatedAt!.compareTo(a.updatedAt!));
                          List<String> notificationDateList = [];
                          for (var element in notifications) {
                            notificationDateList.add(DateFormat('E, MMM d y')
                                .format(element.updatedAt!));
                          }
                          Map<String, List<NotificationModel>>
                              mapNotificationListWithDate = {};
                          for (var date
                              in Set.from(notificationDateList).toList()) {
                            List<NotificationModel> nmList = [];
                            for (var element in notifications) {
                              if (date ==
                                  DateFormat('E, MMM d y')
                                      .format(element.updatedAt!)) {
                                nmList.add(element);
                              }
                            }
                            nmList.sort(
                                (a, b) => b.updatedAt!.compareTo(a.updatedAt!));
                            mapNotificationListWithDate.putIfAbsent(
                                date, () => nmList);
                          }
                          return ListView.builder(
                            itemCount: mapNotificationListWithDate.keys.length,
                            padding: EdgeInsets.only(
                              top: 10.h,
                              bottom: 10.h,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              final notificationDate =
                                  mapNotificationListWithDate.keys
                                      .toList()[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 10.h),
                                    child: Text(
                                      notificationDate,
                                      style: CustomStyle.blackTextSemiBold
                                          .copyWith(
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ...mapNotificationListWithDate[
                                              notificationDate]!
                                          .map((notificationModel) {
                                        return _buildNotification(
                                            notificationModel:
                                                notificationModel);
                                      }).toList(),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        return SizedBox(
                          width: context.widthPx,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 60.w,
                                height: 60.h,
                                child:
                                    SvgPicture.asset(Assets.aspirationAsiaIcon),
                              ),
                              sboxH15,
                              const Text("Oops! No Notifications Available",
                                  style: CustomStyle.blackTextMedium),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return SizedBox(
                          width: context.widthPx,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 60.w,
                                height: 60.h,
                                child:
                                    SvgPicture.asset(Assets.aspirationAsiaIcon),
                              ),
                              sboxH15,
                              const Text("Oops! No Notifications Available",
                                  style: CustomStyle.blackTextMedium),
                            ],
                          ),
                        );
                      }
                      return SizedBox(
                        width: context.widthPx,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50.w,
                              height: 50.h,
                              child: const AppLoader(),
                            ),
                            sboxH5,
                            Text("Loading Notifications...",
                                style: CustomStyle.blackTextMedium
                                    .copyWith(fontSize: 12.sp)),
                          ],
                        ),
                      );
                    });
              }
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  color: Colors.white,
                ),
                width: context.widthPx,
                height: context.heightPx - 120.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Please signup/login to view notifications',
                      style:
                          CustomStyle.blackTextMedium.copyWith(fontSize: 13.sp),
                    ),
                    sboxH10,
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        side: const BorderSide(color: CustomColor.color2a8dc8),
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
            }),
      ),
    );
  }

  ///Build Notification Container
  Widget _buildNotification({required NotificationModel notificationModel}) {
    IconData selectedIcon = Icons.done;
    Color? bookingStatusColor = Colors.indigoAccent;
    String bookingText = 'Booking Placed';
    String bookingSubText =
        "Your booking of ${notificationModel.title} for ${notificationModel.customerName} Start Date: ${DateFormat('E, d MMM y').format(notificationModel.tripStartDate!)} has been successfully placed.";
    String bookingStatus = "";

    ///check order staus enums
    if (notificationModel.status == BookingStatusEnum.bookingCancelled.index) {
      selectedIcon = Icons.close;
      bookingStatusColor = Colors.red;
      bookingStatus = "cancelled";
    } else if (notificationModel.status ==
        BookingStatusEnum.bookingConfirmed.index) {
      bookingStatus = "confirmed";
      selectedIcon = Icons.check_circle_outline_outlined;
      bookingStatusColor = Colors.blue;
    } else if (notificationModel.status ==
        BookingStatusEnum.bookingCompleted.index) {
      bookingStatus = "completed";
      selectedIcon = Icons.check_circle;
      bookingStatusColor = Colors.green;
    } else if (notificationModel.status ==
        BookingStatusEnum.bookingPlaced.index) {
      bookingStatus = "placed";
      selectedIcon = Icons.check;
      bookingStatusColor = Colors.indigoAccent;
    }
    bookingText = 'Booking $bookingStatus';
    bookingSubText =
        'Your booking of ${notificationModel.title} for ${notificationModel.customerName} on ${DateFormat('E, d MMM y').format(notificationModel.tripStartDate!)} has been $bookingStatus.';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      color: Colors.white,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(16.w),
          child: Container(
            height: 55.h,
            width: 55.w,
            color: CustomColor.colorF58420.withOpacity(0.8),
            child: Icon(
              selectedIcon,
              color: Colors.white,
              size: 40.w,
            ),
          ),
        ),
        title: Text(
          bookingText,
          style: CustomStyle.blackTextMedium.copyWith(
            fontSize: 12.sp,
            color: bookingStatusColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          bookingSubText,
          style: CustomStyle.blackTextRegular.copyWith(
            fontSize: 12.sp,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
