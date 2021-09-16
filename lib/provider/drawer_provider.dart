import 'package:flutter/material.dart';

class OnItemClick with ChangeNotifier{
  int currentPageIndex = 0;
  int get index => currentPageIndex;

  void onclick(int index){
    currentPageIndex = index;
    notifyListeners();
  }
}