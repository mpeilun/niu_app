import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/grades/page/final_page.dart';
import 'package:niu_app/grades/page/mid_page.dart';
import 'package:niu_app/grades/page/warn_page.dart';

class Grades extends StatefulWidget {
  final String title;

  Grades({Key? key, required this.title}) : super(key: key);

  @override
  _GradesState createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  final List<Widget> myTabs = [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(
          icon: Icon(Icons.warning_amber_rounded),
        ),
        SizedBox(
          width: 5.0,
        ),
        Text('期中預警'),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(
          icon: Icon(Icons.grading_rounded),
        ),
        SizedBox(
          width: 5.0,
        ),
        Text('期中成績'),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(
          icon: Icon(Icons.whatshot_rounded),
        ),
        SizedBox(
          width: 5.0,
        ),
        Text('期末成績'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          bottom: TabBar(
            indicatorWeight: 5.0,
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: <Widget>[WarmPage(),MidPage(),FinalPage(),
          ],
        ),
      ),
    );
  }
}
