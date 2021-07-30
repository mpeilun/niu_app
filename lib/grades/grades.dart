import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:niu_app/grades/page/final_page.dart';
import 'package:niu_app/grades/page/mid_page.dart';
import 'package:niu_app/grades/page/warn_page.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';

class Grades extends StatefulWidget {
  final String title;
  const Grades({Key? key, required this.title}) : super(key: key);

  @override
  _GradesState createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  final List<Widget> myTabs = [
    CustomTabBar(
      title: '期中成績',
      icon: Icons.grading_rounded,
    ),
    CustomTabBar(
      title: '期末成績',
      icon: Icons.whatshot_rounded,
    ),
    CustomTabBar(
      title: '期中預警',
      icon: Icons.warning_amber_rounded,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            elevation: 0.0,
            title: Text(
              widget.title,
              //style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            /*
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(56.0),
              child: Container(
                height: 56.0,
                child: TabBar(
                  labelPadding: EdgeInsets.zero,
                  indicatorWeight: 5.0,
                  tabs: myTabs,
                ),
              ),
              */
          ),
          body: DefaultTabController(
            length: myTabs.length,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    toolbarHeight: 0.0,
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    floating: true,
                    pinned: false,
                    snap: true,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(56.0),
                      child: Container(
                        height: 56.0,
                        child: TabBar(
                          labelPadding: EdgeInsets.zero,
                          indicatorWeight: 5.0,
                          tabs: myTabs,
                        ),
                      ),
                    ),
                  ),
                  /*
                  SliverToBoxAdapter(
                    child:  Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: ListTile(
                            title: Text(
                              "班級排名：rank\n學期平均：avg",
                              style: TextStyle(fontSize: 24.0, color: Colors.white),
                            ))),
                  )
                  */
                ];
              },
              body: TabBarView(
                children: <Widget>[
                  MidPage(),
                  FinalPage(),
                  WarmPage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
