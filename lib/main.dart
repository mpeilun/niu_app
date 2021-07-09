import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/Test/login.dart';
import 'package:permission_handler/permission_handler.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.storage.request();

  runApp(new MaterialApp(home: MyApp()));
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
      appBar: AppBar(title: Text("功能列表")),
      body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            SizedBox(height: 60),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.login, size: 50, color: Colors.amber),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(),
                                maintainState: false));
                      },
                    ),
                    Text('登入')
                  ]),
                  SizedBox(
                    width: 50,
                  ),
                  Column(children: <Widget>[
                    Icon(
                      Icons.two_k,
                      size: 50,
                      color: Colors.amber,
                    ),
                    Text('成績')
                  ]),
                  SizedBox(
                    width: 50,
                  ),
                  Column(children: <Widget>[
                    Icon(
                      Icons.thirteen_mp,
                      size: 50,
                      color: Colors.amber,
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
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: <Widget>[
                    Icon(
                      Icons.access_alarm,
                      size: 50,
                      color: Colors.amber,
                    ),
                    Text('活動報名')
                  ]),
                  SizedBox(
                    width: 50,
                  ),
                  Column(children: <Widget>[
                    Icon(
                      Icons.access_alarm,
                      size: 50,
                      color: Colors.amber,
                    ),
                    Text('ZUVIO')
                  ]),
                  SizedBox(
                    width: 50,
                  ),
                  Column(children: <Widget>[
                    Icon(
                      Icons.access_alarm,
                      size: 50,
                      color: Colors.amber,
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
                    Icon(
                      Icons.access_alarm,
                      size: 50,
                      color: Colors.amber,
                    ),
                    Text('選課系統')
                  ]),
                  SizedBox(
                    width: 50,
                  ),
                  Column(children: <Widget>[
                    Icon(
                      Icons.access_alarm,
                      size: 50,
                      color: Colors.amber,
                    ),
                    Text('公車')
                  ]),
                  SizedBox(
                    width: 50,
                  ),
                  Column(children: <Widget>[
                    Icon(
                      Icons.access_alarm,
                      size: 50,
                      color: Colors.amber,
                    ),
                    Text('帳號設定')
                  ]),
                ],
              ),
            ),
          ])),
    );
  }
}
