import 'package:asp_asia/theme/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sized_context/sized_context.dart';

import '../../assets/assets.dart';
import '../../theme/custom_style.dart';
import '../custom_sized_box.dart';

class Utils {
  Future pickImageFromGalley() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
  }

  Future clickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
    return await pickedFile!.readAsBytes();
  }

  Widget commonErrorWidget(String? errorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Assets.aspirationAsiaIcon,
          width: 50,
          height: 50,
        ),
        sboxH10,
        Text(
          '$errorMessage',
          style: CustomStyle.blackTextMedium.copyWith(fontSize: 13.sp),
        )
      ],
    );
  }

  Widget commonErrorTextWidget({required BuildContext context, required String errorMessage}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: SizedBox(
        width: context.widthPx,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(color: CustomColor.color2a8dc8)),
            child: Text(
              errorMessage,
              style: CustomStyle.blackTextRegular.copyWith(fontSize: 12.sp),
            ),
          ),
        ),
      ),
    );
  }

  bool isEmail(String em) {
    String p = "[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  String time12HourTo24HourFormat(String time12Hour) {
    DateTime dateTimeSlotEndTime24Hr = DateFormat("hh:mm a").parse(time12Hour);
    String time24Hr = DateFormat.Hm().format(dateTimeSlotEndTime24Hr);
    return time24Hr;
  }

  String timeWithAmPmToOnlyTime({required String timeWithAmPm}) {
    return timeWithAmPm.split(' ')[0];
  }

  TimeOfDay timeStringToTimeOfDay(String time) {
    TimeOfDay timeOfDayEndTime = TimeOfDay(
      hour: int.parse(time.split(':')[0]),
      minute: int.parse(time.split(':')[1]),
    );
    return timeOfDayEndTime;
  }

  double timeToDouble(TimeOfDay timeOfDay) {
    return timeOfDay.hour + timeOfDay.minute / 60.0;
  }

  double timeToDoubleAdding30Min(TimeOfDay timeOfDay) {
    return timeOfDay.hour + timeOfDay.minute / 60.0;
  }

  List<String> getMonthAYearFromCurrent(int length, {required DateTime createdDate}) {
    DateFormat dateFormat = DateFormat("MMM yyyy");

    List<String> years = [];

    int currentYear = createdDate.year;
    int currentMonth = createdDate.month;
    for (int i = 0; i < length; i++) {
      createdDate = DateTime(currentYear, currentMonth + i);
      years.add(dateFormat.format(createdDate));

      if (currentMonth + i == 1) {
        currentYear += 1;
      }
    }
    return years;
  }
}
