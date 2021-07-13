import 'package:flutter/material.dart';
import 'package:niu_app/service/SemesterDate.dart';

class TimeTable extends StatefulWidget {
  final String title = '課表';
  TimeTable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  @override
  Widget build(BuildContext context) {
    var a = SemesterDate();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(),
    );
  }

}
