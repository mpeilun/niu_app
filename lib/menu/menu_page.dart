import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/Components/circle.dart';
import 'package:niu_app/grades/grades.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/menuIcon.dart';
import 'package:niu_app/login/login_page.dart';

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
                    CusIcons(
                      text: '數位園區',
                      icons: MenuIcon.icon_eschool,
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
                    CusIcons(
                      text: '成績',
                      icons: MenuIcon.icon_grades,
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
                    CusIcons(
                      text: '課表',
                      icons: MenuIcon.icon_timetable,
                      press: () {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CusIcons(
                      text: '活動報名',
                      icons: MenuIcon.icon_event,
                      press: () {},
                    ),
                    CusIcons(
                      text: 'ZUVIO',
                      icons: MenuIcon.icon_zuvio,
                      press: () {},
                    ),
                    CusIcons(
                      text: '畢業門檻',
                      icons: MenuIcon.icon_graduation,
                      press: () {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CusIcons(
                      text: '選課系統',
                      icons: MenuIcon.icon_e_school,
                      press: () {},
                    ),
                    CusIcons(
                      text: '公車',
                      icons: MenuIcon.icon_bus,
                      press: () {},
                    ),
                    CusIcons(
                      text: '帳號設定',
                      icons: MenuIcon.icon_account,
                      press: () {},
                    ),
                  ],
                ),
              ]),
        ),
        //Expanded(flex: 0, child: SizedBox()),
        Expanded(flex: 4, child: Image.asset('assets/niu_background.png'))
      ])),
    );
  }
}
