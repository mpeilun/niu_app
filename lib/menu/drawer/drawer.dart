import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niu_app/e_school/e_school.dart';
import 'package:niu_app/graduation/graduation.dart';
import 'package:niu_app/login/login_method.dart';
import 'package:niu_app/login/login_page.dart';
import 'package:niu_app/menu/icons/my_flutter_app_icons.dart';
import 'package:niu_app/menu/satisfaction_survey/form.dart';
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

  // late AnimationController _controller;
  String studentName = '';

  @override
  void initState() {
    super.initState();
    _checkInfo();
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => context.read<DarkThemeProvider>().isDark());
    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 150),
    //   vsync: this,
    // );
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
    final controller = Provider.of<DarkThemeProvider>(context);
    return AnimatedContainer(
      transform: Matrix4.translationValues(widget.drawerXOffset, 0, 0),
      duration: Duration(milliseconds: 150),
      width: 110.0,
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
              size: 40.0,
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
          // createDrawerItem(
          //     context: context,
          //     icon: Icons.mail,
          //     text: '聯絡我們',
          //     onTap: () {
          //       context.read<DrawerProvider>().closeDrawer();
          //       context.read<DrawerProvider>().onclick(5);
          //     }),
          createDrawerItem(
              context: context,
              icon: Icons.receipt_long,
              text: '問卷',
              onTap: () {
                context.read<DrawerProvider>().closeDrawer();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SatisfactionSurvey(),
                        maintainState: false));
              }),
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
          Consumer<DarkThemeProvider>(builder: (context, change, child) {
            return true //change.doneForm
                ? Stack(alignment: Alignment.center, children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        border: Border.all(
                          width: 2,
                          color: change.darkTheme ? Colors.grey.shade600 : Color(0xcb228EE5),
                        ),
                      ),
                      child: AnimateIcons(
                        duration: Duration(milliseconds: 500),
                        startIconColor: Theme.of(context).iconTheme.color,
                        endIconColor: Theme.of(context).iconTheme.color,
                        startIcon: Icons.light_mode,
                        endIcon: Icons.dark_mode,
                        controller: controller.controller,
                        size: 45.0,
                        onEndIconPress: () {
                          controller.controller.animateToStart();
                          change.darkTheme = !change.darkTheme;
                          return true;
                        },
                        onStartIconPress: () =>
                            change.darkTheme = !change.darkTheme,
                      ),
                    ),
                  ])
                : SizedBox();
          })
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
        width: 105.0,
        height: 1.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(colors: [
            themeChange.darkTheme
                ? Color.fromARGB(255, 56, 56, 56)
                : Color.fromARGB(255, 19, 97, 158),
            themeChange.darkTheme
                ? Color.fromARGB(255, 76, 76, 76)
                : Color.fromARGB(203, 34, 142, 229),
            themeChange.darkTheme
                ? Color.fromARGB(0, 72, 72, 72)
                : Color.fromARGB(0, 34, 142, 229),
          ]),
        ),
      ),
    );
  }
}

Widget createDrawerItem(
    {double size = 45.0,
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
    required BuildContext context}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 70.0,
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
