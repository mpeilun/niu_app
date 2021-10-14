import 'package:flutter/material.dart';

import '../TimeTable/BuildTimeTable/TimeCard.dart';

class InfoProvider with ChangeNotifier {
  String _name = '';
  String get name => _name;

  void setName(String str) {
    _name = str;
    notifyListeners();
  }
}
