import 'package:asp_asia/theme/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoDataAvailableWidget extends StatelessWidget {
  const NoDataAvailableWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 200.h,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: CustomColor.colorF58420,
              width: 2,
            ),
          ),
          width: MediaQuery.of(context).size.width / 2,
          height: 50.h,
          child: Center(
            child: Text('No $title Found'),
          ),
        ),
      ),
    );
  }
}
