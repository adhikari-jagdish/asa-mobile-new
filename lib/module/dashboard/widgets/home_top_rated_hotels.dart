import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/utils.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../../hotels/cubit/hotel_cubit.dart';
import '../model/top_rated_hotels_model.dart';

class HomeTopRatedHotels extends StatefulWidget {
  const HomeTopRatedHotels({Key? key}) : super(key: key);

  @override
  State<HomeTopRatedHotels> createState() => _HomeTopRatedHotelsState();
}

class _HomeTopRatedHotelsState extends State<HomeTopRatedHotels> {
  @override
  void initState() {
    super.initState();
    context.read<HotelCubit>().getAllHotels();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Text(
            CommonStrings.topRatedHotels,
            style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 18.sp),
          ),
        ),
        sboxH10,
        BlocBuilder<HotelCubit, HotelState>(
          builder: (context, hotelState) {
            if (hotelState is HotelSuccess) {
              return Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                height: 250.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  controller: ScrollController(),
                  itemBuilder: (context, index) {

                    final hotelModel = hotelState.hotels[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: SizedBox(
                            width: 170.w,
                            height: 150.h,
                            child: CachedNetworkImage(
                              width: 500,
                              height: 400,
                              imageUrl: hotelModel.image ?? '',
                              errorWidget: (context, url, error) => const Icon(
                                Icons.no_photography_outlined,
                                size: 40,
                              ),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        sboxH8,
                        Text(
                          "${hotelModel.title}",
                          style: CustomStyle.blackTextSemiBold.copyWith(
                              color: CustomColor.color2a8dc8, fontSize: 15.sp),
                        ),
                        sboxH3,
                        SizedBox(
                          width: 170.w,
                          child: Wrap(
                            children: [
                              FractionallySizedBox(
                                child: Text(
                                  "${hotelModel.city}",
                                  style: CustomStyle.blackTextSemiBold.copyWith(
                                      color: Colors.grey, fontSize: 13.sp),
                                ),
                                widthFactor: 0.65,
                              ),
                              const FractionallySizedBox(
                                widthFactor: 0.1,
                              ),
                              const FractionallySizedBox(
                                child: Icon(
                                  FontAwesomeIcons.solidStar,
                                  color: CustomColor.colorF58420,
                                  size: 10,
                                ),
                                widthFactor: 0.05,
                              ),
                              FractionallySizedBox(
                                child: Align(
                                  child: Text(
                                    "${hotelModel.rating}",
                                    style: CustomStyle.blackTextSemiBold
                                        .copyWith(
                                            color: Colors.grey,
                                            fontSize: 13.sp),
                                  ),
                                ),
                                widthFactor: 0.2,
                                alignment: Alignment.centerRight,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => sboxW20,
                  itemCount: hotelState.hotels.length > 5
                      ? 5
                      : hotelState.hotels.length,
                ),
              );
            } else if (hotelState is HotelLoading) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  height: 200.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    controller: ScrollController(),
                    itemBuilder: (context, index) => Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: SizedBox(
                        width: 170.w,
                        height: 150.h,
                      ),
                    ),
                    separatorBuilder: (context, index) => sboxW10,
                    itemCount: 5,
                  ),
                ),
              );
            } else if (hotelState is HotelError) {
              return Utils().commonErrorTextWidget(
                  context: context,
                  errorMessage: CommonStrings.topRatedHotelsNotFound);
            }
            return const SizedBox.shrink();
          },
        )
      ],
    );
  }
}
