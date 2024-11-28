import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sized_context/sized_context.dart';

import '../../../theme/custom_style.dart';

class PackageTopImage extends StatelessWidget {
  const PackageTopImage({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    double heightForCarousel = 250.h;
    if (deviceHeight > 900) {
      heightForCarousel = 300.h;
    }
    if (Platform.isIOS) {
      heightForCarousel = 250.h;
      if (deviceHeight > 800) {
        heightForCarousel = 300.h;
      }
    }
    return Stack(
      children: [
        Image(
          image: CachedNetworkImageProvider(
            imageUrl,
          ),
          fit: BoxFit.cover,
          height: heightForCarousel,
          width: double.infinity,
          color: Colors.black.withOpacity(0.5),
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
          errorBuilder: (context, url, error) => const Center(
            child: Icon(Icons.error),
          ),
        ),
        Positioned(
          left: 10.0,
          bottom: 10.0,
          child: SizedBox(
            width: context.widthPx,
            child: Text(
              title,
              style: CustomStyle.whiteTextSemiBold.copyWith(fontSize: 35.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }
}
