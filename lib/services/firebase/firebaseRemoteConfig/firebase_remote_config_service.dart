import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/custom_color.dart';
import '../../../theme/custom_style.dart';

class FirebaseRemoteConfigServices {
  Future<void> versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));
    //Get Latest version info from firebase config
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetchAndActivate();
      double? newVersion;
      if (Platform.isIOS) {
        newVersion = double.parse(remoteConfig
            .getString('aspiration_asia_ios_current_version')
            .trim()
            .replaceAll(".", ""));
      } else {
        newVersion = double.parse(remoteConfig
            .getString('aspiration_asia_current_version')
            .trim()
            .replaceAll(".", ""));
      }
      if (newVersion > currentVersion) {
        // print('new version is greater than current version');
        await _showVersionDialog(context);
      }
    } catch (exception) {
      // print('Unable to fetch remote config wit error :$exception ');
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showVersionDialog(context) async {
    const appStoreUrl =
        'https://apps.apple.com/us/app/aspiration-asia/id15590022391122';
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.sombreroinfotech.aspiration-asia';
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dContext) {
        String title = 'App Update';
        String message =
            'A newer version of the app is available, please update now for new features.';
        String btnUpdateLabel = 'Update Now';
        String btnLabelCancel = 'Later';
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: CustomStyle.blackTextMedium
                .copyWith(color: CustomColor.color2a8dc8),
          ),
          content: Text(
            message,
            style: CustomStyle.blackTextMedium,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                btnUpdateLabel,
                style: CustomStyle.blackTextMedium.copyWith(color: Colors.teal),
              ),
              onPressed: () {
                Navigator.pop(dContext);
                if (Platform.isIOS) {
                  _launchURL(appStoreUrl);
                } else if (Platform.isAndroid) {
                  _launchURL(playStoreUrl);
                }
              },
            ),
            TextButton(
              child: Text(
                btnLabelCancel,
                style: CustomStyle.blackTextMedium.copyWith(color: Colors.red),
              ),
              onPressed: () => Navigator.pop(dContext),
            ),
          ],
        );
      },
    );
  }
}
