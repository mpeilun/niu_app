/*
import 'package:html/dom.dart' hide Text;
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart';
*/
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class semesterDate extends StatefulWidget {
  final String title;
  semesterDate({Key? key, required this.title}) : super(key: key);

  @override
  _semesterDateState createState() => _semesterDateState();
}

class _semesterDateState extends State<semesterDate> {

  void getHttp() async {
    try {
      var response = await Dio().get('http://niu.ouo.tw/');
      print(response);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String semester = "Hi";
    getHttp();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(semester)
          ],
        ),
      ),
    );
  }
}
