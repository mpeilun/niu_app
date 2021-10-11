import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/e_school/e_school.dart';
import 'package:niu_app/graduation/graduation.dart';
import 'package:niu_app/login/login_page.dart';
import 'package:niu_app/menu/icons/my_flutter_app_icons.dart';
import 'package:provider/provider.dart';
import 'package:niu_app/provider/drawer_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawer createState() => new _MyDrawer();
}

class _MyDrawer extends State<MyDrawer> {
  late SharedPreferences prefs;
  String studentId = '';
  String studentName = '';
  String imageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/1/12/White_background.png';

  @override
  void initState() {
    super.initState();
    _checkInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        transform: Matrix4.translationValues(0, 0, 0),
        duration: Duration(milliseconds: 150),
        width: 115.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 13, 71, 161),
              Color.fromARGB(255, 14, 69, 156),
              Color.fromARGB(255, 9, 47, 108),
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 16.0),
            Text(
              studentName,
              style: TextStyle(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Divider(),
            createDrawerItem(
                icon: Icons.home_outlined,
                text: '首頁',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<DrawerProvider>().onclick(0);
                }),
            Divider(),
            createDrawerItem(
                icon: MyFlutterApp.megaphone,
                text: '公告',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<DrawerProvider>().onclick(1);
                }),
            Divider(),
            createDrawerItem(
                size: 45.0,
                icon: MyFlutterApp.calendar,
                text: '行事曆',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<DrawerProvider>().onclick(2);
                }),
            Divider(),
            createDrawerItem(
                icon: Icons.settings_outlined,
                text: '設定',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<DrawerProvider>().onclick(3);
                }),
            Divider(),
            createDrawerItem(
                icon: Icons.info_outline_rounded,
                text: '關於',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<DrawerProvider>().onclick(4);
                }),
            Divider(),
            createDrawerItem(
                icon: Icons.logout_outlined,
                text: '登出',
                onTap: () async {
                  //清除緩存
                  saveGraduationData = false;
                  globalAdvancedTile = [];
                  CookieManager().deleteAllCookies();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.of(context).pop();
                  context.read<DrawerProvider>().onclick(0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(
                                cancelPop: true,
                              ),
                          maintainState: false));
                }),
            Divider(),
            createDrawerItem(
                icon: Icons.bug_report_outlined,
                text: '回報問題',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<DrawerProvider>().onclick(5);
                }),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  _checkInfo() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      studentId = prefs.getString('id')!;
      studentName = prefs.getString('name')!;
      imageUrl =
          "https://acade.niu.edu.tw/NIU/Application/stdphoto.aspx?stno=" +
              studentId;
    });
  }
}

class Divider extends StatelessWidget {
  const Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 14.0, 4.0, 10.0),
      child: Container(
        height: 1.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 33, 150, 243),
            Color.fromARGB(203, 33, 150, 243),
            Color.fromARGB(0, 33, 150, 243),
          ]),
        ),
      ),
    );
  }
}

Widget createDrawerItem(
    {double size = 50.0,
    required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
            size: size,
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: 16.0,
                //fontWeight: FontWeight.bold,
                color: Colors.white),
          )
        ],
      ),
    ),
  );
}
