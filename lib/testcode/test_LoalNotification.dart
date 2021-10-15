import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:niu_app/main.dart';

class TestLocalNotification{
  static void test() async{
    DateTime time = DateTime.now().add(Duration(seconds: 10));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "Test",
        "The First Notification",
      icon: "niu_logo",
      //sound: RawResourceAndroidNotificationSound("a_long_cold_sting"),
      largeIcon: DrawableResourceAndroidBitmap("niu_logo"),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      //sound: "a_long_cold_sting.wav",
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(
        0,
        "title",
        "body",
        time,
        platformChannelSpecifics
    );
  }
}