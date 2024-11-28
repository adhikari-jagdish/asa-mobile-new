import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/no_data_available_widget.dart';
import '../../../theme/custom_style.dart';
import '../model/booking_response_model.dart';

class CompletedTrips extends StatelessWidget {
  final List<dynamic> he = [];

  CompletedTrips({Key? key, required this.bookings}) : super(key: key);

  final List<BookingResponseModel> bookings;

  @override
  Widget build(BuildContext context) {
    if (bookings.isNotEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: [
            ListView.separated(
              itemBuilder: (context, index) =>
                  completedTripIndividualLayout(bookingModel: bookings[index]),
              itemCount: bookings.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) => sboxH10,
            ),
            sboxH10,
          ],
        ),
      );
    } else {
      return const NoDataAvailableWidget(title: 'Trips');
    }
  }

  completedTripIndividualLayout({required BookingResponseModel bookingModel}) {
    List<String> destinations = [];
    if (bookingModel.destinations != null) {
      if (bookingModel.destinations!.isNotEmpty) {
        for (var destination in bookingModel.destinations!) {
          destinations.add(destination.title ?? '');
        }
      }
    }

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green, width: 1.5),
      ),
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Container(
              width: 100.w,
              height: 150.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4), BlendMode.darken),
                  image: CachedNetworkImageProvider(
                    bookingModel.image ?? '',
                    maxHeight: 300,
                    maxWidth: 300,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            title: Text(
              '${bookingModel.title}',
              style: CustomStyle.blackTextBold.copyWith(fontSize: 18.sp),
            ),
            subtitle: bookingModel.durationType != null
                ? Text(
                    '${bookingModel.duration} ${bookingModel.durationType}',
                    style:
                        CustomStyle.blackTextSemiBold.copyWith(fontSize: 15.sp),
                  )
                : Text(
                    '${bookingModel.duration! + 1} N / ${bookingModel.duration} D',
                    style:
                        CustomStyle.blackTextSemiBold.copyWith(fontSize: 15.sp),
                  ),
          ),
          sboxH5,
          Wrap(
            children: [
              FractionallySizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    bookingModel.fullName != null
                        ? '${bookingModel.fullName}'
                        : '--',
                    style:
                        CustomStyle.blackTextSemiBold.copyWith(fontSize: 17.sp),
                  ),
                ),
                widthFactor: 0.45,
              ),
              const FractionallySizedBox(
                widthFactor: 0.05,
              ),
              FractionallySizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    bookingModel.mobileNumber != null
                        ? '${bookingModel.mobileNumber}'
                        : '--',
                    style:
                        CustomStyle.blackTextRegular.copyWith(fontSize: 15.sp),
                  ),
                ),
                widthFactor: 0.45,
              ),
            ],
          ),
          sboxH5,
          Wrap(
            children: [
              FractionallySizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: (bookingModel.destinations != null &&
                          bookingModel.destinations!.isNotEmpty)
                      ? Text(
                          destinations.join(', '),
                          style: CustomStyle.blackTextRegular
                              .copyWith(fontSize: 15.sp),
                        )
                      : Text(
                          '${bookingModel.destination?.title}',
                          style: CustomStyle.blackTextRegular
                              .copyWith(fontSize: 15.sp),
                        ),
                ),
                widthFactor: 0.45,
              ),
              const FractionallySizedBox(
                widthFactor: 0.05,
              ),
              FractionallySizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '${bookingModel.noOfAdults} Adults / ${bookingModel.noOfChildren} Children',
                    style:
                        CustomStyle.blackTextRegular.copyWith(fontSize: 15.sp),
                  ),
                ),
                widthFactor: 0.45,
              ),
            ],
          ),
          sboxH5,
          Wrap(
            children: [
              FractionallySizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '${bookingModel.mealPlan}',
                    style:
                        CustomStyle.blackTextRegular.copyWith(fontSize: 15.sp),
                  ),
                ),
                widthFactor: 0.45,
              ),
              const FractionallySizedBox(
                widthFactor: 0.05,
              ),
              FractionallySizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    bookingModel.hotelStarRating != null
                        ? '${bookingModel.hotelStarRating}'
                        : '--',
                    style:
                        CustomStyle.blackTextRegular.copyWith(fontSize: 15.sp),
                  ),
                ),
                widthFactor: 0.45,
              ),
            ],
          ),
          sboxH5,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DottedLine(
              dashColor: Colors.grey.withOpacity(0.3),
              dashLength: 10,
            ),
          ),
          sboxH15,
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Status: ${CommonStrings.bookingCompleted}',
              style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }
}
