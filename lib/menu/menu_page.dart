import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/Components/circle.dart';
import 'package:niu_app/grades/grades.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/menuIcon.dart';
import 'package:niu_app/login/login_page.dart';
import 'package:niu_app/school_event/school_event.dart';
import 'package:niu_app/testwebview_headless.dart';
import 'package:niu_app/TimeTable/TimeTable.dart';

import 'package:niu_app/service/SemesterDate.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../testwebview.dart';

class StartMenu extends StatefulWidget {
  final String title;

  StartMenu({Key? key, required this.title}) : super(key: key);

  @override
  _StartMenu createState() => new _StartMenu();
}

class _StartMenu extends State<StartMenu> {
  HeadlessInAppWebView? headlessWebView;
  String url = "";

  @override
  void initState() {
    super.initState();
    _checkAccount();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    int day = daysBetween(DateTime.now(), DateTime(2021, 9, 13));
    double goal = 1 - day / 77.0;

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
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://i.pinimg.com/originals/12/6a/8f/126a8f49264261264d29865449fb4ba1.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          SizedBox(height: 10),
          LinearPercentIndicator(
            alignment: MainAxisAlignment.center,
            width: 200.0,
            animation: true,
            animationDuration: 5000,
            lineHeight: 25,
            leading: Text("暑假開始",
                style: TextStyle(color: Colors.green, fontSize: 18)),
            trailing:
                Text("暑假結束", style: TextStyle(color: Colors.red, fontSize: 18)),
            percent: goal,
            center: Text((goal * 100).toStringAsFixed(1) + '%',
                style: TextStyle(color: Colors.blue, fontSize: 16)),
            linearStrokeCap: LinearStrokeCap.butt,
            progressColor: Colors.amber,
          ),
          SizedBox(
            height: 10,
          ),
          Text("剩下$day天",
              style: TextStyle(color: Colors.pinkAccent, fontSize: 18)),
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
          //Expanded(flex: 4, child: Image.asset('assets/niu_background.png'))
        ]),
      )),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  _checkAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('id') == null || prefs.get('pwd') == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    title: '登入',
                  ),
              maintainState: false));
    } else {
      headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse("https://acade.niu.edu.tw/NIU/logout.aspx")),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptCanOpenWindowsAutomatically: true,
          ),
        ),
        onWebViewCreated: (controller) {
          print('HeadlessInAppWebView created!');
        },
        onConsoleMessage: (controller, consoleMessage) {
          print("CONSOLE MESSAGE: " + consoleMessage.message);
        },
        onLoadStart: (controller, url) async {
          print("onLoadStart $url");
          setState(() {
            this.url = url.toString();
          });
        },
        onLoadStop: (controller, url) async {
          print("onLoadStop $url");
          setState(() {
            this.url = url.toString();
          });
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/Default.aspx') {
            login();
          }
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          print("onUpdateVisitedHistory $url");
          setState(() {
            this.url = url.toString();
          });
        },
      );

      headlessWebView?.run();
    }
  }

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? pwd = prefs.getString('pwd');
    await headlessWebView?.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#M_PORTAL_LOGIN_ACNT").value=\'$id\';');
    await headlessWebView?.webViewController.evaluateJavascript(
        source: 'document.querySelector("#M_PW").value=\'$pwd\';');
    Future.delayed(Duration(seconds: 1), () async {
      await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#LGOIN_BTN").click();');
    });
  }
}
