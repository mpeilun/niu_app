import 'dart:async';
import 'dart:io' as dartCookies;
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../advanced_tiles.dart';
import '../e_school.dart';

class ESchoolAnnouncement extends StatefulWidget {
  final courseId;
  final List<AdvancedTile> advancedTile;

  const ESchoolAnnouncement({
    Key? key,
    required this.courseId,
    required this.advancedTile,
  }) : super(key: key);

  @override
  _ESchoolAnnouncementState createState() => new _ESchoolAnnouncementState();
}

class _ESchoolAnnouncementState extends State<ESchoolAnnouncement> {
  final GlobalKey eSchoolAnnouncement = GlobalKey();
  HeadlessInAppWebView? headlessWebView;
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
  double progress = 0;

  @override
  void initState() {
    super.initState();

    if (dartCookies.Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }

    headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse("https://eschool.niu.edu.tw/learn/index.php")),
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
          if (url.toString() == 'https://eschool.niu.edu.tw/mooc/login.php') {
            globalAdvancedTile = [];
            Navigator.pop(context);
            showToast('登入逾時，重新登入中！');
          }
          if (url.toString() == 'https://eschool.niu.edu.tw/learn/index.php') {
            for (int i = 1; i <= 30; i++) {
              await Future.delayed(Duration(milliseconds: 1000), () {});
              print('讀取資料 $i');
              String raw = await controller.evaluateJavascript(
                  source: 'window.frames["s_main"].document.body.innerText');
              if (raw.contains('課程公告板') || raw.contains('請點選課程名稱進入教室')) {
                await Future.delayed(Duration(milliseconds: 200), () async {
                  await controller.evaluateJavascript(
                      source:
                          'parent.chgCourse(' + widget.courseId + ', 1, 1)');
                });
                await Future.delayed(Duration(milliseconds: 1000), () async {
                  await webViewController!.loadUrl(
                      urlRequest: URLRequest(
                          url: Uri.parse(
                              "https://eschool.niu.edu.tw/forum/m_node_list.php")));
                  setState(() {
                    loadState = true;
                  });
                });
                break;
              } else if (i == 30) {
                globalAdvancedTile = [];
                Navigator.pop(context);
                showToast('網路異常');
              }
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
          return JsAlertResponse(
              handledByClient: true, action: JsAlertResponseAction.CONFIRM);
        },
        onLoadResource: (InAppWebViewController controller,
            LoadedResource resource) async {});

    headlessWebView?.run();
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
                        key: eSchoolAnnouncement,
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

                          if (![
                                "http",
                                "https",
                                "file",
                                "chrome",
                                "data",
                                "javascript",
                                "about"
                              ].contains(uri.scheme) ||
                              !uri.toString().contains("eschool.niu.edu.tw")) {
                            if (await canLaunch(uri.toString())) {
                              await launch(
                                uri.toString(),
                              );
                              return NavigationActionPolicy.CANCEL;
                            }
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          print("onLoadStop $url");
                          setState(() {
                            this.url = url.toString();
                          });
                          if (url.toString() ==
                              'https://eschool.niu.edu.tw/forum/m_node_list.php') {
                            await controller.evaluateJavascript(
                                source:
                                    'document.querySelector("body > div.box1.navbar-fixed-top > div.operate").style = \'display: none\'');
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
                          download(url, context);
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
            if (await webViewController!.evaluateJavascript(
                    source:
                        'document.querySelector("body > div.box1.navbar-fixed-top > div > div.bread-navi > table > tbody > tr > td:nth-child(1) > a").title') ==
                '回列表') {
              await webViewController!.goBack();
            } else {
              Navigator.pop(context);
            }
          }
          return false;
        },
        shouldAddCallbacks: true);
  }
}
