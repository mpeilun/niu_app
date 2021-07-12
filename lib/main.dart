import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/menu/menu_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NIU app',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: Colors.blue[900],
        scaffoldBackgroundColor: Colors.grey[200],
        textTheme: GoogleFonts.notoSansTextTheme(textTheme).copyWith(
          headline1: GoogleFonts.oswald(textStyle: textTheme.headline1),
        ),
      ),
      home: StartMenu(
        title: '功能列表',
      ),
    );
  }
}
