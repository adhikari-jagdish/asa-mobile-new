import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../common_strings.dart';

versionCheck(context) async {
  //Get Current installed version of app
  final PackageInfo info = await PackageInfo.fromPlatform();
  double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));
  //Get Latest version info from firebase config
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  double newVersion = currentVersion;

  try {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(milliseconds: 3600),
      ),
    );
    await remoteConfig.fetch();
    await remoteConfig.fetchAndActivate();
    if (Platform.isIOS) {
      remoteConfig.getString('ios_current_version');
      newVersion = double.parse(remoteConfig
          .getString('ios_current_version')
          .trim()
          .replaceAll(".", ""));
    } else if (Platform.isAndroid) {
      remoteConfig.getString('android_current_version');
      newVersion = double.parse(remoteConfig
          .getString('android_current_version')
          .trim()
          .replaceAll(".", ""));
    }

    if (newVersion > currentVersion) {
      _showVersionDialog(context);
    }
  } catch (exception) {
    BotToast.showText(text: CommonStrings.oopsSomethingWentWrong);
  }
}

_showVersionDialog(context) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String title = "New Update Available";
      String message =
          "There is a newer version of app available please update it now.";
      String btnLabel = "Update Now";
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(btnLabel),
            onPressed: () => OpenStore.instance.open(
              androidAppBundleId: CommonStrings.playStoreUrl,
            ),
          ),
        ],
      );
    },
  );
}

_launchURL(String url) async {
  print('Url $url');
  if (await canLaunchUrl(Uri(path: url))) {
    await launchUrl(Uri(path: url));
  } else {
    throw CommonStrings.oopsSomethingWentWrong;
  }
}
