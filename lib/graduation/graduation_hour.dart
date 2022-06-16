import 'dart:convert';
import 'dart:io' as dartCookies;
import 'dart:typed_data';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class GraduationHour extends StatefulWidget {
  const GraduationHour({
    Key? key,
  }) : super(key: key);

  @override
  _GraduationHourState createState() => new _GraduationHourState();
}

class _GraduationHourState extends State<GraduationHour> {
  final GlobalKey graduationHour = GlobalKey();
  InAppWebViewController? webViewController;
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
  List<String> cleanJs = [
    'document.querySelector("body > div.mainwrapper > header > div.header__menu").style = \'display: none;\'',
    'document.querySelector("body > div.mainwrapper > footer").style = \'display: none;\'',
    'document.querySelector("body > div.mainwrapper > div.copyright").style = \'display: none;\'',
    'document.querySelector("body > div.mainwrapper > section.common__section > div > div.inquire__student").style = \'display: none;\'',
    'document.querySelector("body > div.mainwrapper > header").style = \'display: none;\'',
    'document.querySelector("body > div.mainwrapper > section.common__pagetitle").style = \'display: none;\'',
    'document.querySelector("body > div.mainwrapper > a").style = \'display: none;\''
  ];
  double progress = 0;

  @override
  void initState() {
    super.initState();

    if (dartCookies.Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
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
                        visible: !loadState,
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(child: NiuIconLoading(size: 80)),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text(
                                  '此頁面載入時間較長，請耐心等候',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    Visibility(
                      visible: loadState,
                      maintainState: true,
                      child: InAppWebView(
                        key: graduationHour,
                        initialOptions: options,
                        onWebViewCreated: (controller) async {
                          webViewController = controller;

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? id = prefs.getString('id');
                          String? pwd = prefs.getString('pwd');

                          var postData = Uint8List.fromList(
                              utf8.encode("student_id=$id&password=$pwd"));
                          controller.postUrl(
                              url: Uri.parse(
                                  "https://ep.niu.edu.tw/login/student"),
                              postData: postData);
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

                          if (![
                                "http",
                                "https",
                                "file",
                                "chrome",
                                "data",
                                "javascript",
                                "about"
                              ].contains(uri.scheme) ||
                              !uri.toString().contains("niu.edu.tw")) {
                            return NavigationActionPolicy.CANCEL;
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          print("onLoadStop $url");
                          setState(() {
                            this.url = url.toString();
                          });
                          if (url.toString() == 'https://ep.niu.edu.tw/login') {
                            Navigator.pop(context);
                            showToast('網路異常！');
                          }
                          if (url.toString() ==
                              'https://ep.niu.edu.tw/search/learning_certification') {
                            for (int i = 1; i <= 30; i++) {
                              await Future.delayed(
                                  Duration(milliseconds: 1000), () {});
                              print('讀取資料 $i');
                              var raw = await controller.evaluateJavascript(
                                  source:
                                      'document.querySelector("body > div.mainwrapper > section.common__section > div > div.paging > a").innerText');
                              print('rawData $raw');
                              if (raw != null || raw != '') {
                                await Future.delayed(
                                    Duration(milliseconds: 200), () async {
                                  //TODO：Android有顯示問題
                                  //TODO: 改用Stack遮蓋?
                                  cleanJs.forEach((element) async {
                                    await controller.evaluateJavascript(
                                        source: element);
                                  });
                                  setState(() {
                                    loadState = true;
                                  });
                                });
                                break;
                              } else if (i == 30) {
                                Navigator.pop(context);
                                showToast('網路異常');
                                break;
                              }
                            }
                          }
                          if (url.toString() ==
                              'https://ep.niu.edu.tw/login/student') {
                            if ((await webViewController!.evaluateJavascript(
                                        source: 'document.body.innerHTML')
                                    as String)
                                .contains('"status":1')) {
                              await controller.loadUrl(
                                  urlRequest: URLRequest(
                                      url: Uri.parse(
                                          "https://ep.niu.edu.tw/search/learning_certification")));
                            } else {
                              Navigator.pop(context);
                              showToast('網路異常！');
                            }
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
                            (controller, url, androidIsReload) {
                          setState(() {
                            this.url = url.toString();
                          });
                          print(url.toString());
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
                        },
                        onDownloadStart: (controller, url) async {
                          await controller.loadUrl(
                              urlRequest: URLRequest(
                                  url: Uri.parse(
                                      "https://ep.niu.edu.tw/search/learning_certification")));
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
            Navigator.pop(context);
          }
          return false;
        },
        shouldAddCallback: true);
  }
}
