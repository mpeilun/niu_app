import 'package:flutter/material.dart';
import 'package:niu_app/components/menuIcon.dart';
import 'package:niu_app/menu/notification/notificatioon_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnNotifyClick with ChangeNotifier {
  bool isNotification = false;
  bool get notification => isNotification;

  void isNewNotifications(bool index) {
    isNotification = index;
    notifyListeners();
  }

  int notifications = 0; //新的通知數量
  int get newNotifications => notifications;

  void newNotification(int index) {
    notifications = index;
    notifyListeners();
  }

  //NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
  late List<NotificationItem> notificationItem;
  List<NotificationItem> get getNotificationItem => notificationItem;

  void setNotificationItem(List<NotificationItem> list) {
    notificationItem = list;
    notifyListeners();
    final String encodedData = NotificationItem.encode(notificationItem);
    saveToPrefs(encodedData);
  }

  void saveToPrefs(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('---儲存通知數據---');
    print(data);
    prefs.setString('notification_item_key', data);
  }

  void initialNotificationItem(List<NotificationItem> list) async {
    notificationItem = list;
    notifyListeners();
  }
}
