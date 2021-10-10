import 'package:flutter/material.dart';
import 'package:niu_app/components/menuIcon.dart';
import 'package:niu_app/menu/notification/notificatioon_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {

  void dissmisible(int index) {
    _notificationItemList.removeAt(index);
    setNotificationItemList(
        _notificationItemList);
    if (index < _newNotificationsCount) {
      _newNotificationsCount--;
    }
    if (_notificationItemList.length == 0) {
      _isEmpty = true;
    }
  }

  bool _isEmpty = false;
  bool get isEmpty => _isEmpty;

  void setIsEmpty(bool index) {
    _isEmpty = index;
    notifyListeners();
  }

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
    saveNewNotificationsCountToPrefs(_newNotificationsCount);
  }

  void saveNewNotificationsCountToPrefs(int data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('---saveNewNotificationsCountToPrefs---');
    print(data);
    prefs.setInt('new_notifications_count_key', data);
  }

  void initialNewNotifications(int data) async {
    _newNotificationsCount = data;
    notifyListeners();
  }

  //NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
  List<NotificationItem> _notificationItemList = [];
  List<NotificationItem> get notificationItemList => _notificationItemList;

  void setNotificationItemList(List<NotificationItem> list) {
    _notificationItemList = list;
    notifyListeners();
    final String encodedData = NotificationItem.encode(_notificationItemList);
    saveNotificationItemListToPrefs(encodedData);
  }

  void saveNotificationItemListToPrefs(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('---aveNotificationItemListToPrefs---');
    print(data);
    prefs.setString('notification_item_key', data);
  }

  void initialNotificationItem(List<NotificationItem> list) async {
    _notificationItemList = list;
    notifyListeners();
  }
}
