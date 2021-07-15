import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/Components/circle.dart';
import 'package:niu_app/grades/grades.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/menuIcon.dart';
import 'package:niu_app/login/login_page.dart';
import 'package:niu_app/schoolEvent/schoolEvent.dart';
import 'package:niu_app/testwebview_headless.dart';
import 'package:niu_app/TimeTable/TimeTable.dart';

import 'package:niu_app/service/SemesterDate.dart';

import '../testwebview.dart';

class StartMenu extends StatefulWidget {
  final String title;

  StartMenu({Key? key, required this.title}) : super(key: key);

  @override
  _StartMenu createState() => new _StartMenu();
}

class _StartMenu extends State<StartMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleSpacing: 0.0,
        elevation: 0.0,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
          child: Column(children: [
        Expanded(
          flex: 6,
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIcons(
                      title: '數位園區',
                      icon: MenuIcon.icon_eschool,
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      title: '登入',
                                    ),
                                maintainState: false));
                      },
                    ),
                    CustomIcons(
                      title: '成績查詢',
                      icon: MenuIcon.icon_grades,
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Grades(
                                      title: '成績查詢',
                                    ),
                                maintainState: false));
                      },
                    ),
                    CustomIcons(
                      title: '每周課表',
                      icon: MenuIcon.icon_timetable,
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimeTable(),
                                maintainState: false));
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIcons(
                      title: '活動報名',
                      icon: MenuIcon.icon_event,
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SchoolEvent(
                                  title: '活動報名',
                                ),
                                maintainState: false));
                      },
                    ),
                    CustomIcons(
                      title: 'ZUVIO',
                      icon: MenuIcon.icon_zuvio,
                      press: () {},
                    ),
                    CustomIcons(
                      title: '畢業門檻',
                      icon: MenuIcon.icon_graduation,
                      press: () {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIcons(
                      title: '選課系統',
                      icon: MenuIcon.icon_e_school,
                      press: () {},
                    ),
                    CustomIcons(
                      title: '公車動態',
                      icon: MenuIcon.icon_bus,
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebTestHeadless(),
                                maintainState: false));
                      },
                    ),
                    CustomIcons(
                      title: '帳號設定',
                      icon: MenuIcon.icon_account,
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebTest(),
                                maintainState: false));
                      },
                    ),
                  ],
                ),
              ]),
        ),
        Expanded(flex: 4, child: Image.asset('assets/niu_background.png'))
      ])),
    );
  }
}
