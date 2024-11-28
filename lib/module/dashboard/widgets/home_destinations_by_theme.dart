import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:asp_asia/common_utils/custom_sized_box.dart';
import 'package:asp_asia/common_utils/view_utils/clickable_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shimmer/shimmer.dart';

import '../../../theme/custom_style.dart';
import '../../packages/view/package_listing_by_travel_theme.dart';
import '../cubit/packagesByTheme/packages_by_theme_cubit.dart';
import '../model/destinations_by_theme_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDestinationsByTheme extends StatefulWidget {
  const HomeDestinationsByTheme({Key? key}) : super(key: key);

  @override
  State<HomeDestinationsByTheme> createState() =>
      _HomeDestinationsByThemeState();
}

class _HomeDestinationsByThemeState extends State<HomeDestinationsByTheme> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PackagesByThemeCubit>().getAllPackagesByTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<PackagesByThemeCubit, PackagesByThemeState>(
          builder: (context, packagesByThemeState) {
            if (packagesByThemeState is PackagesByThemeSuccess) {
              return SizedBox(
                height: 100.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          width: 150.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                packagesByThemeState
                                    .packagesByThemeList[index].image!,
                                maxHeight: 400,
                                maxWidth: 500,
                              ),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.darken),
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        Positioned(
                          child: Text(
                            packagesByThemeState
                                .packagesByThemeList[index].title!,
                            style: CustomStyle.whiteTextSemiBold,
                          ),
                          bottom: 10.h,
                          left: 10.w,
                        )
                      ],
                    ).clickable(() {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: PackageListingByTravelTheme(
                            packagesByThemeModel: packagesByThemeState
                                .packagesByThemeList[index]),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    });
                  },
                  separatorBuilder: (context, index) {
                    return sboxW10;
                  },
                  itemCount: packagesByThemeState.packagesByThemeList.length,
                ),
              );
            } else if (packagesByThemeState is PackagesByThemeLoading) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: SizedBox(
                  height: 100.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150.w,
                        height: 100.h,
                        color: Colors.white,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return sboxW10;
                    },
                    itemCount: 5,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        )
      ],
    );
  }
}
