import 'dart:isolate';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_eschool.dart';


  late HeadlessInAppWebView _notificationWebView;
  late String _semester;

  void runWebView() {
    List<EschoolData> eschoolData = [];

    _notificationWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse("https://eschool.niu.edu.tw/mooc/login.php")),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useOnLoadResource: true,
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
        },
        onLoadStop: (controller, url) async {
          print("onLoadStop $url");
          if (url.toString() ==
              'https://eschool.niu.edu.tw/mooc/message.php?type=17' ||
              url.toString() == 'https://eschool.niu.edu.tw/mooc/index.php') {
            await _notificationWebView?.webViewController.loadUrl(
                urlRequest: URLRequest(
                    url: Uri.parse(
                        "https://eschool.niu.edu.tw/learn/index.php")));
          } else if (url.toString() ==
              'https://eschool.niu.edu.tw/mooc/login.php') {
            await _login();
          }

          if (url.toString() == 'https://eschool.niu.edu.tw/learn/index.php') {
            await _notificationWebView?.webViewController
                .evaluateJavascript(source: 'parent.s_sysbar.goPersonal()');
            if (advancedTile.isEmpty) {
              _semester = (await _notificationWebView?.webViewController
                  .evaluateJavascript(
                  source:
                  'window.frames[0].document.querySelector("#selcourse > option:nth-child(2)").innerText;')
              as String)
                  .split('_')[0];

              for (int i = 2;
              (await _notificationWebView?.webViewController.evaluateJavascript(
                  source:
                  'window.frames[0].document.querySelector("#selcourse > option:nth-child(' +
                      i.toString() +
                      ')").innerText;') as String)
                  .split('_')[0] ==
                  _semester;
              i++) {
                String courseName = (await _notificationWebView?.webViewController
                    .evaluateJavascript(
                    source:
                    'window.frames[0].document.querySelector("#selcourse > option:nth-child(' +
                        i.toString() +
                        ')").innerText;') as String)
                    .split('_')[1]
                    .split('(')[0];
                String courseId = await _notificationWebView?.webViewController
                    .evaluateJavascript(
                    source:
                    'window.frames[0].document.querySelector("#selcourse > option:nth-child(' +
                        i.toString() +
                        ')").value;') as String;
                advancedTile.add(AdvancedTile(
                    title: courseName, courseId: courseId, semester: semester));
              }
              globalAdvancedTile = advancedTile;
            }
          }
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          print("onUpdateVisitedHistory $url");
        },
        onProgressChanged: (controller, progress) {},
        onJsAlert: (InAppWebViewController controller,
            JsAlertRequest jsAlertRequest) async {
          return JsAlertResponse(
              handledByClient: true, action: JsAlertResponseAction.CONFIRM);
        },
        onLoadResource:
            (InAppWebViewController controller, LoadedResource resource) {});

    _notificationWebView.run();
  }

_login() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('id');
  String? pwd = prefs.getString('pwd');
  await _notificationWebView?.webViewController.evaluateJavascript(
      source: 'document.querySelector("#username").value=\'$id\';');
  await _notificationWebView?.webViewController.evaluateJavascript(
      source: 'document.querySelector("#password").value=\'$pwd\';');
  Future.delayed(Duration(milliseconds: 1000), () async {
    await _notificationWebView?.webViewController.evaluateJavascript(
        source: 'document.querySelector("#btnSignIn").click();');
  });
}
