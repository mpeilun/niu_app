import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/dark_mode/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;
  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
  AnimateIconController _controller = AnimateIconController();
  AnimateIconController get controller => _controller;
  void isDark(){
    if(_darkTheme){
      _controller.animateToEnd();
      print('darkmode');
    }
    notifyListeners();
  }

  bool _doneForm = false;
  bool get doneForm => _doneForm;

  set doneForm(bool value) {
    _doneForm = value;
    notifyListeners();
  }

  void asyncDoneForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('isDoneForm')) {
      _doneForm = prefs.getBool('isDoneForm')!;
      print('isDoneForm State:' + _doneForm.toString());
    }
  }
}
