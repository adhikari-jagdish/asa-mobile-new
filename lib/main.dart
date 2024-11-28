import 'dart:ui';

import 'package:asp_asia/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/cupertino.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'aspiration_asia_app.dart';
import 'common_utils/system_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  StreamingSharedPreferences sharedPreferences =
      await StreamingSharedPreferences.instance;
  SystemUtils().changeSystemBarColor();
  SystemUtils().setOrientation();
  SystemUtils().hideSystemUiOverlay();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    MyApp(
      sharedPreferences: sharedPreferences,
    ),
    /*DevicePreview(
      builder: (context) => MyApp(
        sharedPreferences: sharedPreferences,
      ), // Wrap your app
    ),*/
  );
}

class MyApp extends StatefulWidget {
  final StreamingSharedPreferences? sharedPreferences;

  const MyApp({Key? key, this.sharedPreferences}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AspirationAsiaApp(
      sharedPreferences: widget.sharedPreferences,
    );
  }
}
