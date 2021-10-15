import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/e_school/e_school.dart';
import 'package:niu_app/grades/grades.dart';
import 'package:niu_app/graduation/graduation.dart';
import 'package:niu_app/menu/drawer/drawer.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/menu/icons/my_flutter_app_icons.dart';
import 'package:niu_app/components/login_loading.dart';
import 'package:niu_app/menu/notification/notification_page.dart';
import 'package:niu_app/components/menuIcon.dart';
import 'package:niu_app/login/login_page.dart';
import 'package:niu_app/provider/notification_provider.dart';
import 'package:niu_app/menu/drawer/school%EF%BC%BFschedule.dart';
import 'package:niu_app/school_event/school_event.dart';
import 'package:niu_app/TimeTable/TimeTable.dart';
import 'package:niu_app/service/SemesterDate.dart';
import 'package:niu_app/testcode/test_calendar.dart';
import 'package:niu_app/testcode/test_login.dart';
import 'package:niu_app/testcode/test_webview.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:niu_app/menu/drawer/about.dart';
import 'package:niu_app/menu/drawer/announcement.dart';
import 'package:niu_app/menu/drawer/report.dart';
import 'package:niu_app/menu/drawer/setting.dart';
import 'package:provider/src/provider.dart';
import 'package:niu_app/provider/drawer_provider.dart';

import '../bus.dart';
import '../course＿select.dart';
import '../zuvio.dart';

import 'package:badges/badges.dart';

import 'notification/notification_webview.dart';
import 'package:fluttertoast/fluttertoast.dart';

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        NotificationDrawer(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class StartMenu extends StatefulWidget {
  StartMenu({Key? key}) : super(key: key);

  @override
  _StartMenu createState() => new _StartMenu();
}

class _StartMenu extends State<StartMenu> with SingleTickerProviderStateMixin {
  HeadlessInAppWebView? headlessWebView;
  late SharedPreferences prefs;
  late SemesterDate semester = SemesterDate();
  late int newNotificationsCount;
  String url = "";
  bool loginState = false;
  bool reLogin = false;
  bool isNotification = true;
  bool countState = false;
  bool runTimer = false;
  bool popState = false;

  bool isDrawerOpen = false;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _checkAccount());
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => context.read<DrawerProvider>().setController(AnimationController(
              duration: const Duration(milliseconds: 150),
              vsync: this,
            )));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusHeight = MediaQuery.of(context).padding.top;
    final double screenHeight = MediaQuery.of(context).size.height;
    final title = ['首頁', '公告', '行事曆', '設定', '關於', '回報問題'];
    final pages = [
      LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: screenHeight - statusHeight - 56.0,
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
                            title: '代辦清單',
                            icon: MenuIcon.icon_feedback,
                            size: 40.0,
                            press: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SchoolSchedule(),
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
      AnnouncementPage(),
      SchoolSchedule(),
      SettingPage(),
      AboutPage(),
      ReportPage()
    ];

    if (loginState) {
      return ConditionalWillPopScope(
          child: Scaffold(
            body: Consumer<DrawerProvider>(
              builder: (context, controller, child) => Stack(children: [
                DrawerPage(
                  drawerXOffset: controller.drawerXOffset,
                ),
                WillPopScope(
                  onWillPop: () async {
                    if (context.read<DrawerProvider>().isDrawerOpen) {
                      controller.closeDrawer();
                      return false;
                    } else {
                      return true;
                    }
                  },
                  child: GestureDetector(
                    onHorizontalDragStart: (details) => isDragging = true,
                    onHorizontalDragUpdate: (details) {
                      if (!isDragging) return;
                      const delta = 1;
                      if (details.delta.dx > delta) {
                        controller.openDrawer();
                      }
                      if (details.delta.dx < -delta) {
                        controller.closeDrawer();
                      }
                      isDragging = false;
                    },
                    onTap: () {
                      controller.closeDrawer();
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 28, 28, 28),
                            spreadRadius: 3.0,
                            blurRadius: 20.0,
                            offset: Offset(3.0, 0),
                          ),
                        ],
                      ),
                      transform:
                          Matrix4.translationValues(controller.xOffset, 0, 0),
                      child: AbsorbPointer(
                        absorbing: context.read<DrawerProvider>().isDrawerOpen,
                        child: Scaffold(
                            appBar: AppBar(
                              leading: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {
                                  context.read<DrawerProvider>().isDrawerOpen
                                      ? controller.closeDrawer()
                                      : controller.openDrawer();
                                },
                                child: RotationTransition(
                                  turns: Tween(begin: 0.0, end: 0.25)
                                      .animate(controller.controller),
                                  child: Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(title[controller.index]),
                              titleSpacing: 0.0,
                              actions: [
                                Builder(
                                  builder: (context) => Badge(
                                    position:
                                        BadgePosition.topEnd(top: 1, end: 2),
                                    toAnimate: false,
                                    badgeContent: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        '${context.watch<NotificationProvider>().newNotificationsCount}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.notifications_none),
                                      onPressed: () {
                                        if (context
                                                .read<NotificationProvider>()
                                                .notificationItemList
                                                .length ==
                                            0) {
                                          context
                                              .read<NotificationProvider>()
                                              .setIsEmpty(true);
                                        }
                                        context
                                            .read<NotificationProvider>()
                                            .setNewNotifications(false);
                                        Navigator.of(context)
                                            .push(_createRoute());
                                        //context.read<OnNotifyClick>().newNotification(1); //refresh
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            body: pages[controller.index]),
                      ),
                    ),
                  ),
                )
              ]),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Opacity(
                opacity: 0.5,
                child: Container(
                  height: 40,
                  width: 40,
                  child: FloatingActionButton(
                    heroTag: 'test_1',
                    backgroundColor: Colors.red,
                    child: Icon(FontAwesomeIcons.bomb),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => TestLoginWebView(),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 20),
              Opacity(
                opacity: 0.5,
                child: Container(
                  height: 40,
                  width: 40,
                  child: FloatingActionButton(
                    heroTag: 'test_2',
                    backgroundColor: Colors.red,
                    child: Icon(FontAwesomeIcons.bomb),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestWebView(),
                              maintainState: false));
                    },
                  ),
                ),
              ),
              SizedBox(width: 20),
              Opacity(
                opacity: 0.5,
                child: Container(
                  height: 40,
                  width: 40,
                  child: FloatingActionButton(
                    heroTag: 'test_3',
                    backgroundColor: Colors.red,
                    child: Icon(FontAwesomeIcons.bomb),
                    onPressed: () {
                      FirebaseFirestore.instance.collection("testing").add(
                          {'timestamp': Timestamp.fromDate(DateTime.now())});
                    },
                  ),
                ),
              )
            ]),
          ),
          onWillPop: () async {
            bool isOpen = true;
            if (context.read<DrawerProvider>().isDrawerOpen == false) {
              if (popState == false) {
                popState = true;
                showToast('再返回一次離開APP');
                Future.delayed(Duration(milliseconds: 2000), () async {
                  popState = false;
                });
              } else {
                return true;
              }
              isOpen = false;
            }
            return isOpen;
          },
          shouldAddCallbacks: true);
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
            useShouldInterceptAjaxRequest: true,
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
          // setState(() {
          //   this.url = url.toString();
          // });
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
          // setState(() {
          //   this.url = url.toString();
          // });
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/Default.aspx') {
            login();
          }
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/MainFrame.aspx') {
            if (!reLogin) {
              print('登入成功');
              loginFinished();
              loadDataFormPrefs(context);
              runNotificationWebViewWebView(context, null);
            }
          }
        },
        onLoadError: (InAppWebViewController controller, Uri? url, int code,
            String message) {
          print('onLoadError: url_$url msg_$message');
        },
        onLoadResource:
            (InAppWebViewController controller, LoadedResource resource) {
          print('onLoadResource' + resource.toString());
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          // print("onUpdateVisitedHistory $url");
          // setState(() {
          //   this.url = url.toString();
          // });
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
        onAjaxProgress:
            (InAppWebViewController controller, AjaxRequest ajaxRequest) async {
          // log('ajax progress: $ajaxRequest');
          // print('');
          return AjaxRequestAction.PROCEED;
        },
        onAjaxReadyStateChange: (controller, ajax) async {
          // log('onAjaxReadyStateChange: $ajax');
          // print('AJAX RESPONSE TEXT: ' + ajax.responseText.toString());
          // print('');
          return AjaxRequestAction.PROCEED;
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
