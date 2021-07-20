import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/grades/page/final_page.dart';
import 'package:niu_app/grades/page/mid_page.dart';
import 'package:niu_app/grades/page/warn_page.dart';
import 'package:niu_app/school_event/page/event_signed_page.dart';
import 'package:niu_app/school_event/page/event_page.dart';

class SchoolEvent extends StatefulWidget {
  final String title;

  SchoolEvent({Key? key, required this.title}) : super(key: key);

  @override
  _SchoolEventState createState() => _SchoolEventState();
}

class _SchoolEventState extends State<SchoolEvent> {
  final List<Widget> myTabs = [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(
          icon: Icon(Icons.view_headline),
          text: '活動列表',
        ),
        //SizedBox(width: 5.0,),
        //Text('期中預警'),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(
          icon: Icon(
            Icons.check,
          ),
          text: '已報名',
        ),
        //SizedBox(width: 5.0,),
        //Text('期中成績'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(widget.title),
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
