import 'package:flutter/material.dart';

class OnNotifyClick with ChangeNotifier{
  bool notification = true;
  bool get notify => notification;

  void onclick(bool index){
    notification = index;
    notifyListeners();
  }
}