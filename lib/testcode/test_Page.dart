import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:niu_app/service/LocalNotification.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TestPage extends StatefulWidget {

  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var _dateTime = DateTime.now();
  String title = "Test";
  String body = "Test Message";
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
          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              initialValue: title,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '標題',
                hintText: '請輸入標題',
              ),
              onChanged: (text) {
                if (text != "") {
                  title.replaceAll(",", "");
                }
                title = text;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              initialValue: body,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '名稱',
                hintText: '請輸入名稱',
              ),
              onChanged: (text) {
                if (text != "") {
                  body.replaceAll(",", "");
                }
                body = text;
              },
            ),
          ),
          OutlineButton(
            child: Text("---通知---"),
            onPressed: () async{
              LocalNotification.set(
                  _dateTime,
                  title,
                  body
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("通知發佈在 : ${_dateTime.hour}:${_dateTime.minute}:${_dateTime.second}"),
              ));
            },
          ),
          SizedBox(
            height: 10,
          ),
          OutlineButton(
            child: Text("---FireBase---"),
            onPressed: () async{
              FirebaseFirestore.instance
                  .collection("testing")
                  .add({'timestamp' : Timestamp.fromDate(DateTime.now())});
            },
          ),
        ],
      ),
    );
  }
}
