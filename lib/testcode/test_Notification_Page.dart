import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/service/LocalNotification.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TestNotificationPage extends StatefulWidget {

  const TestNotificationPage({Key? key}) : super(key: key);

  @override
  _TestNotificationPageState createState() => _TestNotificationPageState();
}

class _TestNotificationPageState extends State<TestNotificationPage> {

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
    var _dateTime = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification測試區域'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          LocalNotification.set(
                DateTime.now().add(Duration(seconds: 3)),
                "Test",
                "Test Message"
              );
        },
        child: Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Container(
            height: 100,
            color: Colors.white,
            child: CupertinoDatePicker(
              initialDateTime: _dateTime,
              onDateTimeChanged: (date) {
                setState(() {
                  _dateTime = date;
                });
              },
            ),
          ),
          OutlineButton(
            child: Text("---通知---"),
            onPressed: () async{
              LocalNotification.set(
                  _dateTime,
                  "Test",
                  "Test Message"
              );
            },
          ),
        ],
      ),
    );
  }
}
