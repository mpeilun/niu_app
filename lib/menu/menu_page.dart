import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/e_school/e_school.dart';
import 'package:niu_app/grades/grades.dart';
import 'package:niu_app/grduation/graduation_page.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/menu/loading.dart';
import 'package:niu_app/menuIcon.dart';
import 'package:niu_app/login/login_page.dart';
import 'package:niu_app/provider/drawer_provider.dart';
import 'package:niu_app/school_event/school_event.dart';
import 'package:niu_app/TimeTable/TimeTable.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niu_app/menu/drawer/about.dart';
import 'package:niu_app/menu/drawer/announcement.dart';
import 'package:niu_app/menu/drawer/report.dart';
import 'package:niu_app/menu/drawer/setting.dart';
import 'package:niu_app/menu/icons/my_flutter_app_icons.dart';
import '../testwebview.dart';
import 'drawer/drawer.dart';
import './studentInfo.dart';

class StartMenu extends StatefulWidget {
  StartMenu({Key? key}) : super(key: key);

  @override
  _StartMenu createState() => new _StartMenu();
}

class _StartMenu extends State<StartMenu> {
  HeadlessInAppWebView? headlessWebView;
  String url = "";
  StudentInfo info = StudentInfo("","");
  bool loginState = false;
  bool reLogin = false;

  @override
  void initState() {
    super.initState();
    _checkAccount();
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
    print('menu dispose');
  }

  @override
  Widget build(BuildContext context) {
    final title = ['功能列表', '公告', '設定', '關於', '回報問題'];
    final pages = [LayoutBuilder(
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
                          press: () {},
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
                          press: () async {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.clear(); //清空键值对
                            setState(() async {
                              info = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage(
                                        cancelPop: false,
                                      ),
                                      maintainState: false));
                            });
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
    ), AnnouncementPage(), SettingPage(), AboutPage(), ReportPage()];

    if (loginState) {
      return Scaffold(
          appBar: AppBar(
            title: Text(title[context.watch<OnItemClick>().index]),
            titleSpacing: 0.0,
            elevation: 0.0,
            actions: [
              IconButton(icon: Icon(Icons.search), onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.notifications_none), onPressed: () {}),
            ],
            /* 移到drawer
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            */
          ),
          drawer: MyDrawer(
            info : info,
          ),
          body: pages[context.watch<OnItemClick>().index]);
    } else {
      return Loading();
    }
  }

  _checkAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('id') == null || prefs.get('pwd') == null) {
      info = await Navigator.push(
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
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/logout.aspx') {
            print("Logout and Clean cache");
            controller.clearCache();
            CookieManager().deleteAllCookies();
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
              //--獲取名字--
              String studentName = (await headlessWebView?.webViewController
                  .evaluateJavascript(
                  source:
                  'document.querySelector("#topFrame > frame:nth-child(1)").contentDocument.querySelector("html").querySelector("#form1 > table > tbody > tr > td.title_bg > table > tbody > tr > td:nth-child(4) > span").innerText;')).toString();
              String studentID = prefs.get('id').toString();
              info = StudentInfo(studentName,studentID);
              //-----------

              loginFinished();
            }
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
          reLogin = true;
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
    Future.delayed(Duration(milliseconds: 500), () async {
      await headlessWebView?.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#M_PORTAL_LOGIN_ACNT").value=\'$id\';');
      await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#M_PW").value=\'$pwd\';');
    });
    Future.delayed(Duration(milliseconds: 1000), () async {
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
