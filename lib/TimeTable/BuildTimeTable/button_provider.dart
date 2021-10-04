import 'package:flutter/material.dart';

import 'TimeCard.dart';

class OnTimeCardClick with ChangeNotifier {
  List<String> time = timeName;
  List<String> get getTime => time;

  void setTime(List<String> list) {
    time = list;
    notifyListeners();
  }
}
