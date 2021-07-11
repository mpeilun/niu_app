import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/menu/menu_page.dart';
import 'package:permission_handler/permission_handler.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'NIU app',
    theme: new ThemeData(
      // primarySwatch: Colors.blue,
      primaryColor: Colors.blue[900],
      scaffoldBackgroundColor: Colors.grey[200],
    ),
    home: StartMenu(
      title: '功能列表',
    ),
  ));
}
