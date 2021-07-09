import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/Test/login.dart';
import 'package:permission_handler/permission_handler.dart';

import 'menuIcon.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.storage.request();

  runApp(new MaterialApp(
    home: MyApp(),
    theme: new ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue[800],
      accentColor: Colors.cyan[600],
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('功能列表'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            SizedBox(height: 40),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: <Widget>[
                    IconButton(
                      iconSize: 40,
                      icon: Icon(MenuIcon.icon_eschool, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(),
                                maintainState: false));
                      },
                    ),
                    Text('數位園區')
                  ]),
                  SizedBox(
                    width: 40,
                  ),
                  Column(children: <Widget>[
                    IconButton(
                      iconSize: 40,
                      icon: Icon(
                        MenuIcon.icon_grades,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    Text('成績')
                  ]),
                  SizedBox(
                    width: 40,
                  ),
                  Column(children: <Widget>[
                    IconButton(
                      iconSize: 40,
                      icon: Icon(
                        MenuIcon.icon_timetable,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    Text('課表')
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: <Widget>[
                    IconButton(
                      iconSize: 40,
                      icon: Icon(
                        MenuIcon.icon_event,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    Text('活動報名')
                  ]),
                  SizedBox(
                    width: 40,
                  ),
                  Column(children: <Widget>[
                    IconButton(
                      iconSize: 40,
                      icon: Icon(
                        MenuIcon.icon_zuvio,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    Text('ZUVIO')
                  ]),
                  SizedBox(
                    width: 40,
                  ),
                  Column(children: <Widget>[
                    IconButton(
                      iconSize: 40,
                      icon: Icon(
                        MenuIcon.icon_graduation,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    Text('畢業門檻')
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: <Widget>[
                    IconButton(
                      iconSize: 40,
                      icon: Icon(
                        MenuIcon.icon_e_school,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    Text('選課系統')
                  ]),
                  SizedBox(
                    width: 40,
                  ),
                  Column(children: <Widget>[
                    IconButton(
                      iconSize: 40,
                      icon: Icon(
                        MenuIcon.icon_bus,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    Text('公車')
                  ]),
                  SizedBox(
                    width: 40,
                  ),
                  Column(children: <Widget>[
                    IconButton(
                      iconSize: 40,
                      icon: Icon(
                        MenuIcon.icon_account,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    Text('帳號設定')
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(child: Image.asset('assets/niu_background.png'))
          ])),
    );
  }
}
