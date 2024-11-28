import 'package:flutter/services.dart';

class SystemUtils {
  void changeSystemBarColor({Color? color}) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
  }

  void setOrientation({List<DeviceOrientation>? deviceOrientationList}) {
    SystemChrome.setPreferredOrientations(deviceOrientationList ??
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
  }

  void hideSystemUiOverlay() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void showSystemUiOverlay({List<SystemUiOverlay>? systemUiOverlayList}) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, overlays: systemUiOverlayList ??
        [
          SystemUiOverlay.bottom,
          SystemUiOverlay.top,
        ],
    );
  }
}
