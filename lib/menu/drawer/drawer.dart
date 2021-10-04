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
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 4.0, 10.0),
              child: Container(
                height: 1.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 33, 150, 243),
                    Color.fromARGB(186, 33, 150, 243),
                    Color.fromARGB(0, 33, 150, 243),
                  ]),
                ),
              ),
            ),
            createDrawerItem(
                icon: Icons.home_outlined,
                text: '首頁',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<OnItemClick>().onclick(0);
                }),
            Padding(
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
            ),
            createDrawerItem(
                icon: MyFlutterApp.megaphone,
                text: '公告',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<OnItemClick>().onclick(1);
                }),
            Padding(
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
            ),
            createDrawerItem(
                icon: Icons.settings_outlined,
                text: '設定',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<OnItemClick>().onclick(2);
                }),
            Padding(
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
            ),
            createDrawerItem(
                icon: Icons.info_outline_rounded,
                text: '關於',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<OnItemClick>().onclick(3);
                }),
            Padding(
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
            ),
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
                  context.read<OnItemClick>().onclick(0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(
                                cancelPop: true,
                              ),
                          maintainState: false));
                }),
            Padding(
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
            ),
            createDrawerItem(
                icon: Icons.bug_report_outlined,
                text: '回報問題',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<OnItemClick>().onclick(4);
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

Widget createDrawerItem(
    {required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.white,
          size: 50.0,
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
  );
}
