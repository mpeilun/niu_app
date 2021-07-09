import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/Test/login.dart';
import 'package:permission_handler/permission_handler.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.storage.request();

  runApp(new MaterialApp(
    home: MyApp()
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
          appBar: AppBar(title: Text("功能列表")),
          body: SafeArea(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(), maintainState: false));
                    },),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_alarm,size: 50, color: Colors.amber,),
                    Icon(Icons.access_alarm,size: 50, color: Colors.amber,),
                    Icon(Icons.access_alarm,size: 50, color: Colors.amber,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_alarm,size: 50, color: Colors.amber,),
                    Icon(Icons.access_alarm,size: 50, color: Colors.amber,),
                    Icon(Icons.access_alarm,size: 50, color: Colors.amber,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_alarm,size: 50, color: Colors.amber,),
                    Icon(Icons.access_alarm,size: 50, color: Colors.amber,),
                    Icon(Icons.access_alarm,size: 50, color: Colors.amber,),
                  ],
                ),
          ])),
    );
  }
}