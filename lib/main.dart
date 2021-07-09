import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:niu_app/StartMenu/MainMenu.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'NIU app',
    theme: new ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
    ),
    home: StartMenu(
      title: '功能列表',
    ),
  ));
}
