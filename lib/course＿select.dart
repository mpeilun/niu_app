import 'dart:async';
import 'dart:io' as dartCookies;
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/testcode/test_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/toast.dart';
import 'login/login_method.dart';

class CourseSelect extends StatefulWidget {
  const CourseSelect({
    Key? key,
  }) : super(key: key);

  @override
  _CourseSelectState createState() => new _CourseSelectState();
}

class _CourseSelectState extends State<CourseSelect> {
  final GlobalKey courseSelect = GlobalKey();
  late HeadlessInAppWebView headlessWebView;
  late InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useOnDownloadStart: true,
        useOnLoadResource: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late String url;
  late bool loadState = false;
  late bool firstState = false;
  late String tempWillPopUrl;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    if (dartCookies.Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    // getFromWeb();
    _shouldRunWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
        child: Container(
          child: Scaffold(
            body: SafeArea(
                child: Column(children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    Visibility(
                        visible: !loadState, child: NiuIconLoading(size: 80)),
                    Visibility(
                      visible: loadState,
                      maintainState: true,
                      child: InAppWebView(
                        key: courseSelect,
                        // initialUrlRequest: URLRequest(
                        //     url: Uri.parse(
                        //         "https://eschool.niu.edu.tw/forum/m_node_list.php")),
                        initialOptions: options,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) async {
                          setState(() {
                            this.url = url.toString();
                          });
                        },
                        androidOnPermissionRequest:
                            (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          var uri = navigationAction.request.url!;
                          print('shouldOverrideUrlLoading: ' +
                              navigationAction.request.toString());

                          if (uri.toString().contains('chart.googleapis.com')) {
                            return NavigationActionPolicy.CANCEL;
                          }

                          if (![
                                "http",
                                "https",
                                "file",
                                "chrome",
                                "data",
                                "javascript",
                                "about"
                              ].contains(uri.scheme) ||
                              !uri.toString().contains('niu.edu.tw')) {
                            if (await canLaunch(uri.toString())) {
                              await launch(
                                uri.toString(),
                              );
                              return NavigationActionPolicy.CANCEL;
                            }
                          } else if (uri.toString().contains(
                              'https://acade.niu.edu.tw/NIU/mainframe_open.aspx?mainPage=')) {
                            setState(() {
                              loadState = false;
                            });
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          print("onLoadStop $url");
                          setState(() {
                            this.url = url.toString();
                          });
                          if (url.toString().contains('niu.edu.tw')) {
                            setState(() {
                              loadState = true;
                              firstState = true;
                            });
                          }
                        },
                        onLoadResource: (InAppWebViewController controller,
                            LoadedResource resource) {},
                        onLoadError: (controller, url, code, message) {},
                        onProgressChanged: (controller, progress) {
                          setState(() {
                            this.progress = progress / 100;
                          });
                        },
                        onUpdateVisitedHistory:
                            (controller, url, androidIsReload) async {
                          setState(() {
                            this.url = url.toString();
                          });
                          print('onUpdateVisitedHistory:' + url.toString());
                          if ((url.toString() == '')) {
                            showToast('無法使用此功能');
                            setState(() {
                              loadState = false;
                            });
                            await webViewController?.loadUrl(
                                urlRequest: URLRequest(
                                    url: Uri.parse(
                                        "https://acade.niu.edu.tw/NIU/Application/TKE/TKE20/TKE2011_01.aspx"),
                                    headers: {
                                  "Referer":
                                      "https://acade.niu.edu.tw/NIU/Application/TKE/TKE20/TKE2011_.aspx?progcd=TKE2011"
                                }));
                          }
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(
                              'onConsoleMessage:' + consoleMessage.toString());
                          if (consoleMessage.toString().contains(
                              'Uncaught TypeError: Cannot read property \'focus\' of null')) {
                            showToast('無法使用此功能');
                          }
                        },
                        onJsAlert: (InAppWebViewController controller,
                            JsAlertRequest jsAlertRequest) async {
                          print(jsAlertRequest.message.toString());
                          if (jsAlertRequest.message
                              .toString()
                              .contains('選課期間')) {
                            Navigator.pop(context);
                            showToast('目前非選課時間！');
                          }
                          return JsAlertResponse(
                              handledByClient: true,
                              action: JsAlertResponseAction.CONFIRM);
                        },
                        onDownloadStart: (controller, url) async {
                          download(url, context, null);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ])),
          ),
        ),
        onWillPop: () async {
          if (progress == 1.0) {
            tempWillPopUrl = url.toString();
            if (url.toString() !=
                'https://acade.niu.edu.tw/NIU/Application/TKE/TKE20/TKE2011_01.aspx') {
              setState(() {
                loadState = false;
              });
              await webViewController?.loadUrl(
                  urlRequest: URLRequest(
                      url: Uri.parse(
                          "https://acade.niu.edu.tw/NIU/Application/TKE/TKE20/TKE2011_01.aspx"),
                      headers: {
                    "Referer":
                        "https://acade.niu.edu.tw/NIU/Application/TKE/TKE20/TKE2011_.aspx?progcd=TKE2011"
                  }));
            } else {
              Navigator.pop(context);
            }
          }
          return false;
        },
        shouldAddCallback: true);
  }

  void _shouldRunWebView() async {
    if (await Login.origin().initNiuLoin(context)) {
      webViewController?.loadUrl(
          urlRequest: URLRequest(
              url: Uri.parse(
                  "https://acade.niu.edu.tw/NIU/Application/TKE/TKE20/TKE2011_01.aspx"),
              headers: {
            "Referer":
                "https://acade.niu.edu.tw/NIU/Application/TKE/TKE20/TKE2011_.aspx?progcd=TKE2011"
          }));
    }
  }

  late int num;
  Future<void> getFromWeb() async {
    var _url;
    var loadWeb;
    var loading;


    headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://acade.niu.edu.tw/NIU/Application/TKE/TKE34/TKE3420_01.aspx"),
            headers: {
              "Referer":
                  "https://acade.niu.edu.tw/NIU/Application/TKE/TKE34/TKE3420_.aspx?progcd=TKE3420"
            }),
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
        },
        onLoadStop: (controller, url) async {
          print("onLoadStop $url");
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          print("onUpdateVisitedHistory $url");
          _url = url.toString();
        });

    await Future.delayed(Duration(milliseconds: 500));
    while (_url !=
        "https://acade.niu.edu.tw/NIU/Application/TKE/TKE34/TKE3420_01.aspx")
      await Future.delayed(Duration(milliseconds: 100));
    print("載入：" + _url);

    // 等待網頁載入結束
    do {
      loadWeb = await headlessWebView.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#Span2").innerText.replace(/^\\s*|\\s*\$/g,"");');
      if (loadWeb == "查詢學年期") break;
      await Future.delayed(Duration(milliseconds: 100));
    } while (loadWeb != "查詢學年期");

    // 按下按鈕
    await headlessWebView.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#Q_FACULTY_CODE").value = "LA";');
    await headlessWebView.webViewController.evaluateJavascript(
        source:
            'document.getElementById("QUERY_BTN1").click();');

    // 等待清單載入結束
    do {
      loading = await headlessWebView.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#DataGrid > tbody > tr.mtbGreenBg > th:nth-child(1) > a").innerText.replace(/^\\s*|\\s*\$/g,"");');
      if (loading == "開課系所") break;
      await Future.delayed(Duration(milliseconds: 100));
    } while (loading != "開課系所");

    num = await headlessWebView.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#DataGrid > tbody > tr:nth-child(9) > td:nth-child(10)").innerText;');
    print(num);
  }
}
