import 'package:flutter/material.dart';

import '../TimeTable/BuildTimeTable/TimeCard.dart';

class TimeCardClickProvider with ChangeNotifier {
  List<String> time = timeName;
  List<String> get getTime => time;

  void setTime(List<String> list) {
    time = list;
    notifyListeners();
  }
}
