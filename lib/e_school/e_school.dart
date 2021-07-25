import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/e_school/page/e_school_course_webview.dart';
import 'package:niu_app/menu/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ESchool extends StatefulWidget {
  ESchool({Key? key}) : super(key: key);
  @override
  _ESchoolState createState() => _ESchoolState();
}

class _ESchoolState extends State<ESchool> {
  HeadlessInAppWebView? headlessWebView;
  bool loadState = false;
  String loginState = 'null';
  late String url;
  late String id;
  late String pwd;

  final List<Widget> myTabs = [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(
          // icon: Icon(Icons.view_headline),
          text: '我的課程',
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(
          // icon: Icon(Icons.check),
          text: '所有作業',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
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
              'https://eschool.niu.edu.tw/mooc/message.php?type=17') {
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
    print('login dispose');
  }

  @override
  Widget build(BuildContext context) {
    return loadState
        ? DefaultTabController(
            length: myTabs.length,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                title: Text('數位園區'),
                centerTitle: true,
                bottom: TabBar(
                  indicatorWeight: 5.0,
                  tabs: myTabs,
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  ESchoolCourseWebView(),
                  Center(
                    child: Text(
                      'NIU 宜大學生APP',
                      style: TextStyle(fontSize: 30, color: Colors.red),
                    ),
                  ),
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
    });
  }
}
