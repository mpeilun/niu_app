import 'package:flutter/material.dart';

class AnnouncementProvider with ChangeNotifier{
  List _contents = [];
  List get contents => _contents;

  void setListContents(List list) {
    _contents.addAll(list);
    notifyListeners();
  }
}