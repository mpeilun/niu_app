import 'package:flutter/material.dart';
import 'package:niu_app/components/menuIcon.dart';
import 'package:niu_app/menu/notification/notificatioon_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  bool _isNotification = false;
  bool get isNotification => _isNotification;

  void setNewNotifications(bool index) {
    _isNotification = index;
    notifyListeners();
  }

  int _newNotificationsCount = 0; //新的通知數量
  int get newNotificationsCount => _newNotificationsCount;

  void setNewNotificationsCount(int index) {
    _newNotificationsCount = index;
    notifyListeners();
  }

  //NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
  List<NotificationItem> _notificationItemList = [];
  List<NotificationItem> get notificationItemList => _notificationItemList;

  void setNotificationItemList(List<NotificationItem> list) {
    _notificationItemList = list;
    notifyListeners();
    final String encodedData = NotificationItem.encode(_notificationItemList);
    saveToPrefs(encodedData);
  }

  void saveToPrefs(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('---saveToPrefs---');
    print(data);
    prefs.setString('notification_item_key', data);
  }

  void initialNotificationItem(List<NotificationItem> list) async {
    _notificationItemList = list;
    notifyListeners();
  }
}
