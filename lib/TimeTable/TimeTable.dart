import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:niu_app/service/SemesterDate.dart';
import './BuildTimeTable/ViewPage.dart';
/*  SpannableExtentCountPage  */
/*  EdgeInsets.all(5)         */
/*  crossAxisCount: 5         */
class TimeTable extends StatefulWidget {
  TimeTable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  var a = SemesterDate;
  @override
  Widget build(BuildContext context) {
    return ViewPage.extent();
  }
}