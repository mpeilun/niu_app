import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

class WebTestHeadless extends StatefulWidget {
  @override
  _WebTestHeadlessState createState() => new _WebTestHeadlessState();
}

class _WebTestHeadlessState extends State<WebTestHeadless> {
  HeadlessInAppWebView? headlessWebView;
  String url = "";

  @override
  void initState() {
    super.initState();

    headlessWebView = new HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse("https://acade.niu.edu.tw/NIU/logout.aspx")),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(),
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

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "簡單爬蟲",
            )),
        body: SafeArea(
            child: Column(children: <Widget>[
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await headlessWebView?.webViewController.evaluateJavascript(
                          source:
                          'document.querySelector("#M_PORTAL_LOGIN_ACNT").value=\'b0943034\';');
                      await headlessWebView?.webViewController.evaluateJavascript(
                          source:
                          'document.querySelector("#M_PW").value=\'a1309237\';');
                    },
                    child: Text("輸入帳號密碼")),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await headlessWebView?.webViewController.evaluateJavascript(
                          source: 'document.querySelector("#LGOIN_BTN").click();');
                    },
                    child: Text("登入")),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await headlessWebView?.webViewController.loadUrl(
                          urlRequest: URLRequest(
                              url: Uri.parse(
                                  "https://acade.niu.edu.tw/NIU/Application/ENR/ENR30/ENR3040_01.aspx")));
                    },
                    child: Text("跳轉個人資料頁面")),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      var result = await headlessWebView?.webViewController
                          .evaluateJavascript(
                          source:
                          'document.querySelector("#M_RESIDENCE_ADDR").value;');
                      print(result);
                    },
                    child: Text("獲取個人資料")),
              )
            ])));
  }
}
