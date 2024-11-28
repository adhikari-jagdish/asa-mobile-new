import 'package:asp_asia/common_utils/custom_sized_box.dart';
import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:asp_asia/theme/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../module/packages/bloc/hotel_star_rating_toggle_cubit.dart';

class HotelStarRatingDialogWithSingleSelection extends StatelessWidget {
  const HotelStarRatingDialogWithSingleSelection({
    Key? key,
    required this.hotelStarOptions,
  }) : super(key: key);

  final List<String> hotelStarOptions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: hotelStarOptions.length,
              itemBuilder: (context, index) {
//                print('Hotel Star Options ${hotelStarOptions.length}');
                final option = hotelStarOptions[index];
                return Wrap(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Text(option),
                    ),
                    FractionallySizedBox(
                      child: SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: BlocBuilder<HotelStarRatingToggleCubit, HotelStarRatingToggleModelForCubit>(
                          builder: (context, hotelStarRatingModel) {
                            return Checkbox(
                                shape: const CircleBorder(),
                                value: index == hotelStarRatingModel.index ? true : false,
                                onChanged: (val) {
                                  context.read<HotelStarRatingToggleCubit>().emit(
                                        HotelStarRatingToggleModelForCubit(
                                          index: index == hotelStarRatingModel.index && !val! ? hotelStarRatingModel.index : index,
                                          hotelStarRating: option,
                                        ),
                                      );
                                });
                          },
                        ),
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    const Divider(),
                    sboxH5,
                  ],
                );
              },
            ),
          ),
          const Divider(),
          sboxH30,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'OK',
                style: CustomStyle.blackTextSemiBold.copyWith(color: Colors.teal, fontSize: 14.sp),
              ).clickable(() {
                Navigator.of(context).pop();
              }),
            ],
          )
        ],
      ),
    );
  }
}
