import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PackageListingIndividualForShimmer extends StatelessWidget {
  const PackageListingIndividualForShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.withOpacity(0.5),
      child: Container(
        height: MediaQuery.of(context).size.width * 0.5,
        width: MediaQuery.of(context).size.width * 0.45,
        color: Colors.white,
      ),
    );
  }
}
