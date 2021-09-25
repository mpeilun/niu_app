import 'package:flutter/material.dart';
import 'package:niu_app/my_flutter_app_icons.dart';
import '../studentInfo.dart';
import 'package:provider/provider.dart';
import 'package:niu_app/provider/drawer_provider.dart';


class MyDrawer extends StatefulWidget {
  final StudentInfo info;
  MyDrawer({Key? key, required this.info}) : super(key: key);

  @override
  _MyDrawer createState() => new _MyDrawer();
}

class _MyDrawer extends State<MyDrawer> {

  @override
  Widget build(BuildContext context) {

    final studentId = widget.info.ID;
    final studentName = widget.info.name;

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
                        child: Image.network(
                          "https://acade.niu.edu.tw/NIU/Application/stdphoto.aspx?stno=" + studentId ,
                          width: 75,
                          height: 75,
                        ),
                      ),
                    ),
                    Text(
                      '$studentName\n${studentId.toUpperCase()}',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    createDrawerItem(icon: Icons.home, text: '首頁', onTap: (){
                      Navigator.of(context).pop();
                      context.read<OnItemClick>().onclick(0);
                    }),
                    createDrawerItem(icon: MyFlutterApp2.megaphone, text: '公告', onTap: () {
                      Navigator.of(context).pop();
                      context.read<OnItemClick>().onclick(1);
                    }),
                    createDrawerItem(icon: Icons.settings, text: '設定', onTap: () {
                      Navigator.of(context).pop();
                      context.read<OnItemClick>().onclick(2);
                    }),
                    createDrawerItem(icon: Icons.info, text: '關於', onTap: () {
                      Navigator.of(context).pop();
                      context.read<OnItemClick>().onclick(3);
                    }),
                    createDrawerItem(icon: Icons.logout, text: '登出', onTap: () {
                      Navigator.of(context).pop();
                    }),
                    createDrawerItem(icon: Icons.bug_report, text: '回報問題', onTap: () {
                      Navigator.of(context).pop();
                      context.read<OnItemClick>().onclick(4);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget createDrawerItem(
    {required IconData icon, required String text, required GestureTapCallback onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: Colors.black,),
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