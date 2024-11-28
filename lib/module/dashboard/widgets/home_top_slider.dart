import 'dart:io';
import 'package:asp_asia/common_utils/common_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/carousel/carousel_cubit.dart';
import '../cubit/home_carousel_height_toggle_cubit.dart';

class HomeTopSlider extends StatefulWidget {
  const HomeTopSlider({Key? key}) : super(key: key);

  @override
  State<HomeTopSlider> createState() => _HomeTopSliderState();
}

class _HomeTopSliderState extends State<HomeTopSlider> {

  @override
  void initState() {
    super.initState();

    context.read<CarouselCubit>().getAllCarousel();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    // print('height device: ${MediaQuery.of(context).size.height}');
    double heightForCarousel = 250.h;
    if (deviceHeight > 900) {
      heightForCarousel = 300.h;
    }
    if (!kIsWeb){
      if (Platform.isIOS) {
        heightForCarousel = 250.h;
        if (deviceHeight > 800) {
          heightForCarousel = 300.h;
        }
      }
    }
    context.read<HomeCarouselHeightToggleCubit>().emit(heightForCarousel);
    return BlocBuilder<CarouselCubit, CarouselState>(
      builder: (context, carouselState) {
        if (carouselState is CarouselLoading) {
          return SizedBox(
            height: heightForCarousel,
            width: double.infinity,
          );
        } else if (carouselState is CarouselSuccess) {
          return CarouselSlider(
            options: CarouselOptions(
              height: heightForCarousel,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: carouselState.carouselList.length != 1,
              reverse: false,
              autoPlay: carouselState.carouselList.length != 1,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 900),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (index, changeReason) {
                //print('image chang: $index');
              },
              scrollDirection: Axis.horizontal,
            ),
            items: carouselState.carouselList.map((cm) {
              return Image(
                image: CachedNetworkImageProvider(
                  cm.image!,
                ),
                fit: BoxFit.cover,
                height: heightForCarousel,
                width: double.infinity,
                color: Colors.black.withOpacity(0.1),
                colorBlendMode: BlendMode.srcOver,
                filterQuality: FilterQuality.low,
                loadingBuilder: (context, child, ic) {
                  if (ic != null) {
                    if (ic.expectedTotalBytes != null) {
                      if (ic.cumulativeBytesLoaded != ic.expectedTotalBytes) {
                        return SizedBox(
                          height: heightForCarousel,
                          width: double.infinity,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }
                  }
                  return child;
                },
                errorBuilder: (context, url, error) => const Center(child: Icon(Icons.error)),
              );
            }).toList(),
          );
        }
        return Image(
          image: const CachedNetworkImageProvider(
            CommonStrings.sampleImage,
          ),
          fit: BoxFit.cover,
          height: heightForCarousel,
          width: double.infinity,
          color: Colors.black.withOpacity(0.1),
          colorBlendMode: BlendMode.srcOver,
          filterQuality: FilterQuality.low,
          loadingBuilder: (context, child, ic) {
            if (ic != null) {
              if (ic.expectedTotalBytes != null) {
                if (ic.cumulativeBytesLoaded != ic.expectedTotalBytes) {
                  return SizedBox(
                    height: heightForCarousel,
                    width: double.infinity,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }
            }
            return child;
          },
          errorBuilder: (context, url, error) => const Center(child: Icon(Icons.error)),
        );
      },
    );
  }
}
