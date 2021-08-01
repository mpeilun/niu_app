import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/e_school/e_school.dart';
import 'package:niu_app/grades/grades.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/menu/loading.dart';
import 'package:niu_app/menuIcon.dart';
import 'package:niu_app/login/login_page.dart';
import 'package:niu_app/school_event/school_event.dart';
import 'package:niu_app/TimeTable/TimeTable.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../testwebview.dart';

class StartMenu extends StatefulWidget {
  StartMenu({Key? key}) : super(key: key);

  @override
  _StartMenu createState() => new _StartMenu();
}

class _StartMenu extends State<StartMenu> {
  HeadlessInAppWebView? headlessWebView;
  String url = "";
  bool loginState = false;

  @override
  void initState() {
    super.initState();
    _checkAccount();
  }

  @override
  void dispose() {
    super.dispose();
    print('menu dispose');
  }

  @override
  Widget build(BuildContext context) {
    if (loginState) {
      return Scaffold(
          appBar: AppBar(
            title: Text('功能列表'),
            titleSpacing: 0.0,
            elevation: 0.0,
            actions: [
              IconButton(icon: Icon(Icons.search), onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.notifications_none), onPressed: () {}),
            ],
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ),
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(children: [
                    SizedBox(
                      height: 8.0,
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                          builder: (context) => ESchool(),
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
                                press: () {},
                              ),
                              CustomIcons(
                                title: '更改帳號',
                                icon: MenuIcon.icon_account,
                                press: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                                cancelPop: false,
                                              ),
                                          maintainState: false));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/niu_background.png',
                      ),
                    ),
                    Expanded(
                      //測試用按鈕登出行政系統
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: FloatingActionButton(
                            backgroundColor: Colors.red,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebTest(),
                                      maintainState: false));
                            }),
                      ),
                    )
                  ]),
                ),
              );
            },
          ));
    } else {
      return Loading();
    }
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
                    cancelPop: true,
                  ),
              maintainState: false));
      Future.delayed(Duration(seconds: 3), () async {
        loginFinished();
      });
    } else {
      headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse("https://acade.niu.edu.tw/NIU/MainFrame.aspx")),
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
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/MainFrame.aspx') {
            print('登入成功');
            loginFinished();
          }
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          print("onUpdateVisitedHistory $url");
          setState(() {
            this.url = url.toString();
          });
        },
        onJsAlert: (InAppWebViewController controller,
            JsAlertRequest jsAlertRequest) async {
          print(jsAlertRequest.message!);
          return JsAlertResponse(
              handledByClient: true, action: JsAlertResponseAction.CONFIRM);
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
    Future.delayed(Duration(milliseconds: 1000), () async {
      await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#LGOIN_BTN").click();');
    });
  }

  void loginFinished() {
    setState(() {
      loginState = true;
    });
  }
}
