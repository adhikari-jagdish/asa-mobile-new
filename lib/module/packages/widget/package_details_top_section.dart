import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sized_context/sized_context.dart';

import '../../../theme/custom_style.dart';
import '../bloc/package_details_top_image_height_toggle_cubit.dart';
import '../model/package_model.dart';

class PackageDetailsTopSection extends StatelessWidget {
  const PackageDetailsTopSection({
    Key? key,
    required this.packageModel,
  }) : super(key: key);

  final PackageModel packageModel;

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
    context.read<PackageDetailsTopImageHeightToggleCubit>().emit(heightForCarousel);
    return ClipRRect(
      //borderRadius: const BorderRadius.only(bottomRight: Radius.circular(100)),
      child: Image(
        image: CachedNetworkImageProvider(
          packageModel.image ?? '',
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
        errorBuilder: (context, url, error) => SizedBox(
          height: heightForCarousel,
          width: double.infinity,
          child: const Center(
            child: Icon(
              Icons.no_photography_outlined,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
