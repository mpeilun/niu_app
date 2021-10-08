import 'package:flutter/material.dart';
import 'package:niu_app/components/menuIcon.dart';
import 'package:niu_app/menu/notification/notificatioon_items.dart';

class OnNotifyClick with ChangeNotifier{
  bool isNotification = true;
  bool get notification => isNotification;


  void onclick(bool index){
    isNotification = index;
    notifyListeners();
  }

  int notifications = 0; //新的通知數量
  int get newNotifications => notifications;

  void newNotification(int index){
    notifications = index;
    notifyListeners();
  }


  List<NotificationItem> notificationItem = [
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
  ];
  List<NotificationItem> get getNotificationItem => notificationItem;

  void setNotificationItem(List<NotificationItem> list) {
    notificationItem = list;
    notifyListeners();
  }

}