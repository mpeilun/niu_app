import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Grades extends StatefulWidget {
  final String title;

  Grades({Key? key, required this.title}) : super(key: key);

  @override
  _GradesState createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.grading),
                text: '期中成績',
              ),
              Tab(
                text: '期中預警',
              ),
              Tab(
                text: '期末成績',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Container(child: Text('你覺得TAPBAR的文字', style: TextStyle(fontSize: 64.0,),))),
            Text('要加ICON嗎'),
            Text('要加ICON嗎'),
          ],
        ),
      ),
    );
  }
}
