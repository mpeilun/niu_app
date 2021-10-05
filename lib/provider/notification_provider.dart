import 'package:flutter/material.dart';

class OnNotifyClick with ChangeNotifier{
  bool notification = true;
  bool get notify => notification;

  void onclick(bool index){
    notification = index;
    notifyListeners();
  }

  int newNotify = 0; //新的通知數量
  int get newNotifications => newNotify;

  void newNotification(int index){
    newNotify = index;
    notifyListeners();
  }
}