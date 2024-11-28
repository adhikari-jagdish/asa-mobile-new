import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../../../enum/booking_status_enum.dart';

class FirebaseCloudMessagingServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //resigter the device to firebase messaging and provide the token
  Future<String?> getTokenForPushNotification() async {
    return await _firebaseMessaging.getToken();
  }

  //subscribe to push notification topics to get notification pushed based on topics
  Future<void> subscribeToPushNotificationTopics(String topic) async {
    return await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unSubscribeToPushNotificationTopics(String topic) async {
    return await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  void initFirebaseMessagingPushNotification(
    BuildContext context, {
    required Future<dynamic> Function(Map<String, dynamic>) myBackgroundMessageHandler,
    FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin,
  }) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Map<String, dynamic> data = message.data;
      await showBookingNotification(data, flutterLocalNotificationsPlugin!);
    });
  }

  Future showBookingNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '${message['title']}',
      '${message['tripStartDate']}',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: const BigTextStyleInformation(''),
    );
    String bookingStatus = "";
    int status = int.parse(message['bookingStatus']);

    ///check order staus enums
    if (status == BookingStatusEnum.bookingCancelled.index) {
      bookingStatus = "cancelled";
    } else if (status == BookingStatusEnum.bookingConfirmed.index) {
      bookingStatus = "confirmed";
    } else if (status == BookingStatusEnum.bookingPlaced.index) {
      bookingStatus = "placed";
    }

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Booking $bookingStatus',
      'Dear ${message['customerName']}, your booking of ${message['title']} for ${DateFormat('E, d MMM y').format(DateTime.parse(message['tripStartDate']))} has been $bookingStatus.',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
