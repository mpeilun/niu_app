import 'package:flutter/material.dart';
import 'package:niu_app/school_event/components/event_signed_card.dart';

class EventSignedRefreshProvider with ChangeNotifier {

  List<EventSigned> _data = [];
  List<EventSigned> get data => _data;

  void setData(List<EventSigned> data) {
    _data = data;
    notifyListeners();
  }
  void clearData(){
    _data.clear();
    print(_data);
    print("123456789");
    notifyListeners();
  }
}