import 'package:flutter/material.dart';

class DrawerProvider with ChangeNotifier {
  int currentPageIndex = 0;
  int get index => currentPageIndex;

  void onclick(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  double xOffset = 0;
  double drawerXOffset = -115.0;
  late AnimationController _controller;
  AnimationController get controller => _controller;
  void setController(AnimationController index) {
    _controller = index;
    notifyListeners();
  }

  bool isDrawerOpen = false;
  bool isDragging = false;

  void openDrawer() {
      xOffset = 115.0;
      drawerXOffset = 0;
      isDrawerOpen = true;
      _controller.forward();
      notifyListeners();
  }

  void closeDrawer() {
      xOffset = 0;
      drawerXOffset = -115.0;
      isDrawerOpen = false;
      _controller.reverse();
      notifyListeners();
  }
}
