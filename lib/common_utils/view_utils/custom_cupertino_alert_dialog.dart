import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/custom_style.dart';

class CustomCupertinoAlertDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? positiveText;
  final String? negativeText;
  final void Function(BuildContext dialogContext)? onNegativeActionClick;
  final void Function()? onPositiveActionClick;
  final bool shouldShowNegativeButton;

  const CustomCupertinoAlertDialog({Key? key,
    this.negativeText,
    required this.positiveText,
    required this.content,
    required this.title,
    this.onNegativeActionClick,
    required this.onPositiveActionClick,
    this.shouldShowNegativeButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("$title", style: CustomStyle.blackTextMedium.copyWith(fontSize: 14.sp)),
      content: Text(
        "$content",
        style: CustomStyle.blackTextMedium.copyWith(fontSize: 16.sp),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onPositiveActionClick,
            child: Text(
              "$positiveText",
              style: CustomStyle.blackTextMedium.copyWith(fontSize: 14.sp, color: Colors.blueAccent),
            )),
        if (shouldShowNegativeButton)
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onNegativeActionClick != null
                ? () {
                    onNegativeActionClick!(context);
                  }
                : () {
                    Navigator.of(context).pop();
                  },
            child: Text(
              "$negativeText",
              style: CustomStyle.blackTextMedium.copyWith(fontSize: 14.sp, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
