import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/grades/page/final_page.dart';
import 'package:niu_app/grades/page/mid_page.dart';
import 'package:niu_app/grades/page/warn_page.dart';
import 'package:niu_app/school_event/page/event_signed_page.dart';
import 'package:niu_app/school_event/page/event_page.dart';

class ESchool extends StatefulWidget {
  ESchool({
    Key? key,
  }) : super(key: key);

  @override
  _ESchoolState createState() => _ESchoolState();
}

class _ESchoolState extends State<ESchool> {
  final List<Widget> myTabs = [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(
          // icon: Icon(Icons.view_headline),
          text: '我的課程',
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(
          // icon: Icon(Icons.check),
          text: '所有作業',
        ),
      ],
    ),
  ];

  //12374

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('數位園區'),
          centerTitle: true,
          bottom: TabBar(
            indicatorWeight: 5.0,
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            EventPage(),
            EventSignedPage(),
          ],
        ),
      ),
    );
  }
}
