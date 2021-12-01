import 'package:flutter/material.dart';
import 'package:niu_app/dark_mode/shared_preferences.dart';
import 'package:provider/provider.dart';
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

  bool _doneForm = false;
  bool get doneForm => _doneForm;

  set doneForm(bool value) {
    _doneForm = value;
    notifyListeners();
  }

  void asyncDoneForm(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isDoneForm') == null) {
      Provider.of<DarkThemeProvider>(context, listen: false).doneForm = false;
    } else {
      print('---------' + prefs.getBool('isDoneForm').toString());
      Provider.of<DarkThemeProvider>(context, listen: false).doneForm =
          prefs.getBool('isDoneForm')!;
      print('---------' +
          Provider.of<DarkThemeProvider>(context, listen: false)
              .doneForm
              .toString());
    }
  }
}
