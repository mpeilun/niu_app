import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/e_school/e_school.dart';
import 'package:niu_app/grades/grades.dart';
import 'package:niu_app/graduation/graduation.dart';
import 'package:niu_app/menu/drawer/drawer.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/menu/loading.dart';
import 'package:niu_app/menu/notification/notification_page.dart';
import 'package:niu_app/components/menuIcon.dart';
import 'package:niu_app/login/login_page.dart';
import 'package:niu_app/provider/notification_provider.dart';
import 'package:niu_app/school_event/school_event.dart';
import 'package:niu_app/TimeTable/TimeTable.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:niu_app/menu/drawer/about.dart';
import 'package:niu_app/menu/drawer/announcement.dart';
import 'package:niu_app/menu/drawer/report.dart';
import 'package:niu_app/menu/drawer/setting.dart';
import 'package:niu_app/menu/drawer/test_announcement.dart';
import 'package:provider/src/provider.dart';
import 'package:niu_app/provider/drawer_provider.dart';

import '../bus.dart';
import '../course＿select.dart';
import '../zuvio.dart';

class StartMenu extends StatefulWidget {
  StartMenu({Key? key}) : super(key: key);

  @override
  _StartMenu createState() => new _StartMenu();
}

class _StartMenu extends State<StartMenu> {
  HeadlessInAppWebView? headlessWebView;
  late SharedPreferences prefs;
  String url = "";
  bool loginState = false;
  bool reLogin = false;
  bool isNotification = true;
  bool countState = false;
  bool runTimer = false;

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
    final title = ['首頁', '公告', '設定', '關於', '回報問題'];
    final pages = [
      LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
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
                            title: '每週課表',
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
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Zuvio(),
                                      maintainState: false));
                            },
                          ),
                          CustomIcons(
                            title: '畢業門檻',
                            icon: MenuIcon.icon_graduation,
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Graduation(),
                                      maintainState: false));
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomIcons(
                            title: '選課系統',
                            icon: MenuIcon.icon_e_school,
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CourseSelect(),
                                      maintainState: false));
                            },
                          ),
                          CustomIcons(
                            title: '公車動態',
                            icon: MenuIcon.icon_bus,
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Bus(),
                                      maintainState: false));
                            },
                          ),
                          CustomIcons(
                            title: '更改帳號',
                            icon: MenuIcon.icon_account,
                            press: () async {
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
              ]),
            ),
          );
        },
      ),
      // TestAnnouncementPage(),
      AnnouncementPage(),
      SettingPage(),
      AboutPage(),
      ReportPage()
    ];

    if (loginState) {
      return Scaffold(
          appBar: AppBar(
            title: Text(title[context.watch<OnItemClick>().index]),
            titleSpacing: 0.0,
            actions: [
              Builder(
                builder: (context) => Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_none),
                      onPressed: () {
                        context.read<OnNotifyClick>().onclick(false);
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                    Positioned(
                      right: 10.0,
                      top: 13.0,
                      child: Icon(Icons.brightness_1,
                          color: context.watch<OnNotifyClick>().notify
                              ? Colors.red
                              : Colors.transparent,
                          size: 9.0),
                    )
                  ],
                ),
              )
            ],
          ),
          drawer: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Theme.of(context)
                    .scaffoldBackgroundColor, //This will change the drawer background to blue.
                //other styles
              ),
              child: MyDrawer()),
          endDrawer: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Theme.of(context)
                    .scaffoldBackgroundColor, //This will change the drawer background to blue.
                //other styles
              ),
              child: NotificationDrawer()),
          body: pages[context.watch<OnItemClick>().index]);
    } else {
      return WillPopScope(
          onWillPop: true ? () async => false : null, child: Loading());
    }
  }

  //TODO:卡登問題
  _checkAccount() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.get('id') == null || prefs.get('pwd') == null) {
      Future.delayed(Duration(milliseconds: 1000), () async {
        loginFinished();
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    cancelPop: true,
                  ),
              maintainState: false));
    } else {
      headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse("https://acade.niu.edu.tw/NIU/MainFrame.aspx")),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptCanOpenWindowsAutomatically: true,
          ),
        ),
        onWebViewCreated: (controller) async {
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
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/MainFrame.aspx' &&
              countState == false &&
              loginState == false &&
              runTimer == false) {
            runTimer = true;
            for (int i = 1; i <= 120; i++) {
              await Future.delayed(Duration(milliseconds: 1000), () {});
              print('登入檢測 $i');
              if (countState == true) {
                print('------跳過卡登------');
                loginState = true;
                break;
              } else if (loginState == true) {
                break;
              } else if (i % 10 == 0 && loginState == false) {
                print("Logout and Clean cache");
                headlessWebView?.webViewController.clearCache();
                CookieManager().deleteAllCookies();
                await headlessWebView?.webViewController.loadUrl(
                    urlRequest: URLRequest(
                        url: Uri.parse(
                            "https://acade.niu.edu.tw/NIU/Default.aspx")));
                countState = true;
                break;
              } else if (i == 120) {
                runTimer = false;
                countState = false;
                break;
              }
            }
          }
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
            if (!reLogin) {
              print('登入成功');
              loginFinished();
            }
          }
        },
        onLoadResource:
            (InAppWebViewController controller, LoadedResource resource) {
          print('onLoadResource' + resource.toString());
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          // print("onUpdateVisitedHistory $url");
          setState(() {
            this.url = url.toString();
          });
        },
        onProgressChanged: (controller, progress) {
          print('onProgressChanged:' + progress.toString());
          //print('進度 $webProgress');
        },
        onJsAlert: (InAppWebViewController controller,
            JsAlertRequest jsAlertRequest) async {
          reLogin = true;
          print(jsAlertRequest.message!);
          print("Logout and Clean cache");
          controller.clearCache();
          CookieManager().deleteAllCookies();
          await headlessWebView?.webViewController
              .loadUrl(urlRequest: URLRequest(url: Uri.parse("about:blank")));
          await Future.delayed(Duration(milliseconds: 100), () async {
            await headlessWebView?.webViewController.loadUrl(
                urlRequest: URLRequest(
                    url: Uri.parse(
                        "https://acade.niu.edu.tw/NIU/Default.aspx")));
          });
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
    Future.delayed(Duration(milliseconds: 500), () async {
      print('keying');
      await headlessWebView?.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#M_PORTAL_LOGIN_ACNT").value=\'$id\';');
      await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#M_PW").value=\'$pwd\';');
    });
    Future.delayed(Duration(milliseconds: 1000), () async {
      print('clickLogin');
      await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#LGOIN_BTN").click();');
    });
    reLogin = false;
  }

  void loginFinished() {
    setState(() {
      loginState = true;
    });
  }
}
