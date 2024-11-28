import 'package:asp_asia/common_utils/custom_sized_box.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sized_context/sized_context.dart';

import '../../../common_utils/custom_functions.dart';
import '../../../common_utils/view_utils/shared_preference_master.dart';
import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';
import '../model/package_model.dart';

class PackageListingIndividualDesign extends StatelessWidget {
  const PackageListingIndividualDesign({
    Key? key,
    required this.packageModel,
  }) : super(key: key);

  final PackageModel packageModel;

  @override
  Widget build(BuildContext context) {
    final selectedCurrency =
        RepositoryProvider.of<SharedPreferenceMaster>(context)
            .currencySelected
            .getValue();

    ///Condition one if package contains hotel category
    int rateIndexByHotelCategory = 0;
    int? packageRate = 0;
    rateIndexByHotelCategory =
        CustomFunctions().getIndexByHotelCategory(packageModel);
    packageRate = CustomFunctions()
        .packageRateAccordingToCurrencyAndHotelCategory(
            packageModel, rateIndexByHotelCategory, selectedCurrency);

    int? packageRateBeforeDiscount = packageRate;
    if (packageModel.discountInPercentage != null) {
      if (packageModel.discountInPercentage! > 0) {
        packageRateBeforeDiscount =
            (((packageModel.discountInPercentage! / 100) * packageRate!)
                    .floor()) +
                packageRate;
      }
    }
    return Card(
      elevation: 2,
      child: SizedBox(
        width: context.widthPx / 2.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                memCacheHeight: 400,
                memCacheWidth: 500,
                height: 150.h,
                width: context.widthPx,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                imageUrl: packageModel.image ?? '',
                errorWidget: (context, url, error) => const Icon(
                  Icons.no_photography_outlined,
                  size: 40,
                ),
              ),
            ),
            sboxH10,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                '${packageModel.title}',
                style: CustomStyle.blackTextBold.copyWith(fontSize: 14.sp),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            sboxH3,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: packageModel.durationType != null
                  ? Text(
                      '${packageModel.duration!} ${packageModel.durationType}',
                      style: CustomStyle.blackTextMedium.copyWith(
                          fontSize: 13.sp, color: CustomColor.colorF58420),
                      overflow: TextOverflow.visible,
                    )
                  : Text(
                      '${packageModel.duration!} Days',
                      style: CustomStyle.blackTextMedium.copyWith(
                          fontSize: 13.sp, color: CustomColor.colorF58420),
                      overflow: TextOverflow.visible,
                    ),
            ),
            sboxH5,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Wrap(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.65,
                    child: Text(
                      'Starting from:',
                      style: CustomStyle.blackTextMedium.copyWith(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const FractionallySizedBox(
                    widthFactor: 0.05,
                  ),
                  packageModel.discountInPercentage != null
                      ? FractionallySizedBox(
                          widthFactor: 0.28,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            child: Text(
                              '${packageModel.discountInPercentage}% Off',
                              style: CustomStyle.whiteTextMedium
                                  .copyWith(fontSize: 10.sp),
                              textAlign: TextAlign.center,
                            ),
                            decoration: BoxDecoration(
                              color: CustomColor.color2a8dc8.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            sboxH5,
            packageModel.discountInPercentage != null
                ? Wrap(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            '$selectedCurrency $packageRateBeforeDiscount',
                            style: CustomStyle.blackTextSemiBold.copyWith(
                                fontSize: 12.sp,
                                color: Colors.black,
                                decoration: TextDecoration.lineThrough),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            '$selectedCurrency $packageRate',
                            style: CustomStyle.blackTextSemiBold
                                .copyWith(fontSize: 15.sp, color: Colors.teal),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      )
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      '$selectedCurrency $packageRate',
                      style: CustomStyle.blackTextSemiBold
                          .copyWith(fontSize: 15.sp, color: Colors.teal),
                      overflow: TextOverflow.visible,
                    ),
                  ),
            sboxH2,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: packageModel.durationType != null
                  ? Text(
                      'Per Person',
                      style: CustomStyle.blackTextMedium.copyWith(
                          fontSize: 11.sp,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  : Text(
                      'Per Person on twin sharing',
                      style: CustomStyle.blackTextMedium.copyWith(
                          fontSize: 11.sp,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
            ),
            sboxH5,
          ],
        ),
      ),
    );
  }
}
