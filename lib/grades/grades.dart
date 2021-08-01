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

class _GradesState extends State<Grades> with SingleTickerProviderStateMixin {
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

  /*
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length,);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  */

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
          ),
          centerTitle: true,
        ),
        body: NestedScrollView(
          //controller: _scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                toolbarHeight: 0.0,
                elevation: 0.0,
                centerTitle: true,
                floating: true,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(56.0),
                  child: Container(
                    height: 56.0,
                    child: TabBar(
                      //controller: _tabController,
                      labelPadding: EdgeInsets.zero,
                      indicatorWeight: 5.0,
                      tabs: myTabs,
                    ),
                  ),
                ),
              ),
              /*
              SliverToBoxAdapter(
                child: PreferredSize(
                  preferredSize: Size.fromHeight(56.0),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    height: 56.0,
                    child: TabBar(
                      //controller: _tabController,
                      labelPadding: EdgeInsets.zero,
                      indicatorWeight: 5.0,
                      tabs: myTabs,
                    ),
                  ),
                ),
              ),
               */
            ];
          },
          body: TabBarView(
            //controller: _tabController,
            children: <Widget>[
              MidPage(),
              FinalPage(),
              WarmPage(),
            ],
          ),
        ),
      ),
    );
  }
}
