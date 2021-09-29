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
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ClipOval(
                        child: Container(
                          color: Colors.white,
                          child: Image.network(
                            imageUrl,
                            width: 75,
                            height: 75,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '$studentName\n${studentId.toUpperCase()}',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  createDrawerItem(
                      icon: Icons.home,
                      text: '首頁',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<OnItemClick>().onclick(0);
                      }),
                  createDrawerItem(
                      icon: MyFlutterApp.megaphone,
                      text: '公告',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<OnItemClick>().onclick(1);
                      }),
                  createDrawerItem(
                      icon: Icons.settings,
                      text: '設定',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<OnItemClick>().onclick(2);
                      }),
                  createDrawerItem(
                      icon: Icons.info,
                      text: '關於',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<OnItemClick>().onclick(3);
                      }),
                  createDrawerItem(
                      icon: Icons.logout,
                      text: '登出',
                      onTap: () async {
                        //清除緩存
                        saveGraduationData = false;
                        globalAdvancedTile = [];
                        CookieManager().deleteAllCookies();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear(); //清空键值对
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      cancelPop: true,
                                    ),
                                maintainState: false));
                      }),
                  createDrawerItem(
                      icon: Icons.bug_report,
                      text: '回報問題',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<OnItemClick>().onclick(4);
                      }),
                ],
              ),
            ),
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
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    ),
  );
}
