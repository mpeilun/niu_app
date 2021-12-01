import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/e_school/e_school.dart';
import 'package:niu_app/graduation/graduation.dart';
import 'package:niu_app/login/login_method.dart';
import 'package:niu_app/login/login_page.dart';
import 'package:niu_app/menu/icons/my_flutter_app_icons.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:niu_app/provider/info_provider.dart';
import 'package:provider/provider.dart';
import 'package:niu_app/provider/drawer_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({
    Key? key,
    required this.drawerXOffset,
  }) : super(key: key);
  final double drawerXOffset;

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  late SharedPreferences prefs;

  String studentName = '';

  @override
  void initState() {
    super.initState();
    _checkInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _checkInfo() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('name')) {
      studentName = prefs.getString('name')!;
    }
    context.read<InfoProvider>().setName(studentName);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AnimatedContainer(
      transform: Matrix4.translationValues(widget.drawerXOffset, 0, 0),
      duration: Duration(milliseconds: 150),
      width: 115.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeChange.darkTheme
                ? Color(0xff212121)
                : Color.fromARGB(255, 13, 71, 161),
            themeChange.darkTheme
                ? Color(0xff212121)
                : Color.fromARGB(255, 14, 69, 156),
            themeChange.darkTheme
                ? Color(0xff212121)
                : Color.fromARGB(255, 9, 47, 108),
          ],
        ),
      ),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 16.0),
          Text(
            '${context.watch<InfoProvider>().name}',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Divider(),
          createDrawerItem(
              context: context,
              icon: Icons.home_outlined,
              text: '首頁',
              onTap: () {
                context.read<DrawerProvider>().closeDrawer();
                context.read<DrawerProvider>().onclick(0);
              }),
          Divider(),
          createDrawerItem(
              context: context,
              icon: MyFlutterApp.megaphone,
              text: '公告',
              onTap: () {
                context.read<DrawerProvider>().closeDrawer();
                context.read<DrawerProvider>().onclick(1);
              }),
          Divider(),
          createDrawerItem(
              context: context,
              size: 45.0,
              icon: MyFlutterApp.calendar,
              text: '行事曆',
              onTap: () {
                context.read<DrawerProvider>().closeDrawer();
                context.read<DrawerProvider>().onclick(2);
              }),
          // Divider(),
          // createDrawerItem(
          //     context: context,
          //     icon: Icons.settings_outlined,
          //     text: '設定',
          //     onTap: () {
          //       context.read<DrawerProvider>().closeDrawer();
          //       context.read<DrawerProvider>().onclick(3);
          //     }),
          Divider(),
          createDrawerItem(
              context: context,
              icon: Icons.info_outline_rounded,
              text: '關於',
              onTap: () {
                context.read<DrawerProvider>().closeDrawer();
                context.read<DrawerProvider>().onclick(4);
              }),
          Divider(),
          createDrawerItem(
              context: context,
              icon: Icons.mail,
              text: '聯絡我們',
              onTap: () {
                context.read<DrawerProvider>().closeDrawer();
                context.read<DrawerProvider>().onclick(5);
              }),
          SizedBox(height: 20.0),
          Divider(),
          createDrawerItem(
              context: context,
              icon: Icons.logout_outlined,
              text: '登出',
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(),
                        maintainState: false));
              }),
          SizedBox(
            height: 20,
          ),
          Visibility(
              visible: Provider.of<DarkThemeProvider>(context).getDoneForm,
              child: Switch(
                  value: themeChange.darkTheme,
                  onChanged: (value) {
                    themeChange.darkTheme = value;
                  }))
        ],
      ),
    );
  }
}

class Divider extends StatelessWidget {
  const Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 14.0, 4.0, 10.0),
      child: Container(
        height: 1.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(colors: [
            themeChange.darkTheme
                ? Color.fromARGB(255, 56, 56, 56)
                : Color.fromARGB(255, 33, 150, 243),
            themeChange.darkTheme
                ? Color.fromARGB(255, 109, 109, 109)
                : Color.fromARGB(203, 33, 150, 243),
            themeChange.darkTheme
                ? Color.fromARGB(0, 72, 72, 72)
                : Color.fromARGB(0, 33, 150, 243),
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
    required GestureTapCallback onTap,
    required BuildContext context}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: themeChange.darkTheme ? Color(0xe0ffffff) : Colors.white,
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
