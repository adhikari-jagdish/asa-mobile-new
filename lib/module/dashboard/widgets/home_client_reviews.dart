import 'package:asp_asia/theme/custom_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common_utils/common_strings.dart';
import '../../../common_utils/custom_sized_box.dart';
import '../../../common_utils/view_utils/utils.dart';
import '../../../theme/custom_style.dart';
import '../../client_reviews/bloc/client_reviews_cubit.dart';
import '../../client_reviews/model/client_reviews_model.dart';

class HomeClientReviews extends StatefulWidget {
  const HomeClientReviews({Key? key}) : super(key: key);

  @override
  State<HomeClientReviews> createState() => _HomeClientReviewsState();
}

class _HomeClientReviewsState extends State<HomeClientReviews> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ClientReviewsCubit>().getClientReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Text(
            CommonStrings.clientReviews,
            style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 18.sp),
          ),
        ),
        sboxH10,
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: BlocBuilder<ClientReviewsCubit, ClientReviewsState>(
            builder: (context, state) {
              if (state is ClientReviewsSuccess) {
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: ScrollController(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final clientReview = state.clientReviews[index];
                    return Column(
                      children: [
                        ListTile(
                          leading: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${clientReview.customer!.profileImage}",
                              fit: BoxFit.fill,
                              width: 55,
                              height: 65,
                              errorWidget: (context, url, error) =>
                                  const SizedBox(
                                width: 55,
                                height: 65,
                                child: Center(
                                  child: Icon(
                                    Icons.no_photography_outlined,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            "${clientReview.customer!.fullName}",
                            style: CustomStyle.blackTextSemiBold,
                          ),
                          subtitle: RatingBarIndicator(
                            rating: clientReview.rating != null
                                ? clientReview.rating!.toDouble()
                                : 0.0,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: CustomColor.colorF58420,
                            ),
                            itemSize: 10.0,
                            direction: Axis.horizontal,
                          ),
                          trailing: Text(
                            DateFormat('d, MMM y')
                                .format(clientReview.updatedAt!),
                            style: CustomStyle.blackTextSemiBold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            "${clientReview.reviewMessage}",
                            style: CustomStyle.blackTextRegular,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => sboxH20,
                  itemCount: state.clientReviews.length > 5
                      ? 3
                      : state.clientReviews.length,
                );
              } else if (state is ClientReviewsLoading) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Card(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: SizedBox(height: 120.h),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is ClientReviewsError) {
                return Utils().commonErrorTextWidget(
                    context: context,
                    errorMessage: CommonStrings.clientReviewsNotFound);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
