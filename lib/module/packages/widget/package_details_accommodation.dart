import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../theme/custom_style.dart';
import '../../hotels/model/hotel_model.dart';
import '../bloc/hotel_star_rating_toggle_cubit.dart';

class PackageDetailsAccommodation extends StatelessWidget {
  const PackageDetailsAccommodation({Key? key, required this.hotels}) : super(key: key);

  final List<HotelModel> hotels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            CommonStrings.hotels,
            style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 18.sp),
          ),
        ),
        sboxH20,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<HotelStarRatingToggleCubit, HotelStarRatingToggleModelForCubit>(
            builder: (context, hotelStarRatingModel) {
              final filteredHotels = hotels.where((element) => element.hotelCategory == hotelStarRatingModel.hotelStarRating).toList();
              return DataTable(
                border: TableBorder.all(),
                columns: [
                  DataColumn(
                      label: Text(
                        'Destination',
                        style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 15.sp),
                      )),
                  DataColumn(
                    label: Text(
                      'Property',
                      style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 15.sp),
                    ),
                  ),
                ],
                rows: filteredHotels
                    .map(
                  ((element) =>
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(element.city!)),
                          DataCell(Text(element.title!)),
                        ],
                      )),
                )
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
