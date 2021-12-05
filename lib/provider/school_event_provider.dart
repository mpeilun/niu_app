import 'package:flutter/material.dart';
import 'package:niu_app/school_event/components/event_signed_card.dart';

class SchoolEventProvider with ChangeNotifier{
  List<EventSigned> _data = [];
  List<EventSigned> get data => _data;

  void setListData(List<EventSigned> list) {
    _data.addAll(list);
    notifyListeners();
  }
}