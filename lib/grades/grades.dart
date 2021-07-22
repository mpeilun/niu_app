import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/grades/page/final_page.dart';
import 'package:niu_app/grades/page/mid_page.dart';
import 'package:niu_app/grades/page/warn_page.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';

class Grades extends StatefulWidget {
  final String title;

  Grades({Key? key, required this.title}) : super(key: key);

  @override
  _GradesState createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  final List<Widget> myTabs = [
    CustomTabBar(title: '期中預警', icon: Icons.warning_amber_rounded,),
    CustomTabBar(title: '期中成績', icon: Icons.grading_rounded,),
    CustomTabBar(title: '期末成績', icon: Icons.whatshot_rounded,),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          elevation: 0.0,
          title: Text(widget.title, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(65.0),
            child: Container(
              height: 65.0,
              child: TabBar(
                labelPadding: EdgeInsets.zero,
                indicatorWeight: 5.0,
                tabs: myTabs,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            WarmPage(),
            MidPage(),
            FinalPage(),
          ],
        ),
      ),
    );
  }
}
