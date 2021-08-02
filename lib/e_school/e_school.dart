import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/e_school/page/e_school_course_webview.dart';
import 'package:niu_app/e_school/page/lesson_page.dart';
import 'package:niu_app/e_school/page/work_page.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/menu/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ESchool extends StatefulWidget {
  ESchool({Key? key}) : super(key: key);
  @override
  _ESchoolState createState() => _ESchoolState();
}

class _ESchoolState extends State<ESchool> with SingleTickerProviderStateMixin{
  HeadlessInAppWebView? headlessWebView;
  bool loadState = false;
  String loginState = 'null';
  late String url;
  late String id;
  late String pwd;

  final List<Widget> myTabs = [
    CustomTabBar(title: '我的課程', icon: Icons.view_headline),
    CustomTabBar(title: '所有作業', icon: Icons.check),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length,);
    _scrollController = ScrollController();
    headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse("https://eschool.niu.edu.tw/mooc/login.php")),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useOnLoadResource: true,
            useOnDownloadStart: true,
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

          if (url.toString() ==
                  'https://eschool.niu.edu.tw/mooc/message.php?type=17' ||
              url.toString() == 'https://eschool.niu.edu.tw/mooc/index.php') {
            await headlessWebView?.webViewController.loadUrl(
                urlRequest: URLRequest(
                    url: Uri.parse(
                        "https://eschool.niu.edu.tw/learn/index.php")));
          } else if (url.toString() ==
              'https://eschool.niu.edu.tw/mooc/login.php') {
            await _login();
          }

          if (url.toString() == 'https://eschool.niu.edu.tw/learn/index.php') {
            headlessWebView?.webViewController
                .evaluateJavascript(source: 'parent.s_sysbar.goPersonal()');
            print('登入成功');
            setState(() {
              loadState = true;
            });
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
          // await headlessWebView?.webViewController.loadUrl(
          //     urlRequest: URLRequest(
          //         url: Uri.parse("https://acade.niu.edu.tw/NIU/Default.aspx")));
          loginState = jsAlertRequest.message!;
          return JsAlertResponse(
              handledByClient: true, action: JsAlertResponseAction.CONFIRM);
        },
        onLoadResource:
            (InAppWebViewController controller, LoadedResource resource) {
          //print(resource.toString());
        });

    headlessWebView?.run();
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
    loginState = 'null';
    loadState = false;
    _tabController.dispose();
    _scrollController.dispose();
    print('login dispose');
  }

  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return loadState
        ? Scaffold(
          appBar: AppBar(
            title: Text(
              '數位園區',
            ),
            centerTitle: true,
          ),
          body: NestedScrollView(
            controller: _scrollController,
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                /*
                SliverAppBar(
                  toolbarHeight: 0.0,
                  elevation: 0.0,
                  centerTitle: true,
                  floating: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(56.0),
                    child: Container(
                      height: 56.0,
                      child: TabBar(
                        controller: _tabController,
                        labelPadding: EdgeInsets.zero,
                        indicatorWeight: 5.0,
                        tabs: myTabs,
                      ),
                    ),
                  ),
                ),
                */

                SliverToBoxAdapter(
                  child: PreferredSize(
                    preferredSize: Size.fromHeight(56.0),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      height: 56.0,
                      child: TabBar(
                        controller: _tabController,
                        labelPadding: EdgeInsets.zero,
                        indicatorWeight: 5.0,
                        tabs: myTabs,
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                LessonPage(),
                WorkPage(),
              ],
            ),
          ),
        )
        : Loading();
  }

  _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? pwd = prefs.getString('pwd');
    await headlessWebView?.webViewController.evaluateJavascript(
        source: 'document.querySelector("#username").value=\'$id\';');
    await headlessWebView?.webViewController.evaluateJavascript(
        source: 'document.querySelector("#password").value=\'$pwd\';');
    Future.delayed(Duration(milliseconds: 1000), () async {
      await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#btnSignIn").click();');
      //TODO 網頁異常狀態判定
      //TODO 登入動畫？
    });
  }
}

