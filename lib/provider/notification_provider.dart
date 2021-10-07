import 'package:flutter/material.dart';

class OnNotifyClick with ChangeNotifier{
  bool isNotification = true;
  bool get noti => isNotification;


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
}