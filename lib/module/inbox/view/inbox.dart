import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_utils/common_strings.dart';
import '../../../theme/custom_style.dart';
import 'chat.dart';
import 'notification.dart';

class Inbox extends StatefulWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            CommonStrings.trips,
            style: CustomStyle.blackTextBold.copyWith(fontSize: 27.sp),
          ),
          bottom: TabBar(
            controller: _controller,
            tabs: [
              Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  'Notification',
                  style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 14.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  'Chat',
                  style: CustomStyle.blackTextSemiBold.copyWith(fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _controller,
            children: const [
              Notifications(),
              Chat(),
            ],
          ),
        ),
      ),
    );
  }
}
