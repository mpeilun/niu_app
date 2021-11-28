import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/school_event/page/event_signed_page.dart';
import 'package:niu_app/school_event/page/event_page.dart';

ScrollController schoolEventScrollController = ScrollController();

class SchoolEvent extends StatefulWidget {
  final String title;

  SchoolEvent({Key? key, required this.title}) : super(key: key);

  @override
  _SchoolEventState createState() => _SchoolEventState();
}

class _SchoolEventState extends State<SchoolEvent> with SingleTickerProviderStateMixin{
  final List<Widget> myTabs = [
    CustomTabBar(title: '活動報名', icon: Icons.view_headline,),
    CustomTabBar(title: '已報名', icon: Icons.check,),
  ];
  
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: myTabs.length,
    );
    _tabController.addListener(() {FocusScope.of(context).unfocus();});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(titleSpacing: 0.0,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: NestedScrollView(
        controller: schoolEventScrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              toolbarHeight: 0.0,
              elevation: 0.0,
              centerTitle: true,
              floating: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(56.0),
                child: Container(
                  color: Theme.of(context).primaryColor,
                  height: 56.0,
                  child: TabBar(
                    controller: _tabController,
                    labelPadding: EdgeInsets.zero,
                    indicatorWeight: 5.0,
                    tabs: myTabs,
                  ),
                ),
              ),
            ),

          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            EventPage(),
            EventSignedPage(),
          ],
        ),
      ),
      );
  }
}
