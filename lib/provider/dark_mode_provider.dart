import 'package:flutter/material.dart';
import 'package:niu_app/dark_mode/shared_preferences.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;
  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }

  bool _isDoneForm = true;
  bool get getDoneForm => _isDoneForm;
  set setDoneForm(bool value) {
    _isDoneForm = value;
    notifyListeners();
  }
}
