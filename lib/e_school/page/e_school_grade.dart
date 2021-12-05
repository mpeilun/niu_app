import 'dart:async';
import 'dart:io' as dartCookies;

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../advanced_tiles.dart';
import '../e_school.dart';

class ESchoolGrade extends StatefulWidget {
  final courseId;
  final List<AdvancedTile> advancedTile;

  const ESchoolGrade({
    Key? key,
    required this.courseId,
    required this.advancedTile,
  }) : super(key: key);

  @override
  _ESchoolGradeState createState() => new _ESchoolGradeState();
}

class _ESchoolGradeState extends State<ESchoolGrade> {
  final GlobalKey eSchoolGrade = GlobalKey();
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
  late bool headlessLoadState = false;
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
              var raw = await controller.evaluateJavascript(
                  source: 'window.frames["s_main"].document.body.innerText');
              print('rawData $raw');
              if (raw != null || raw != '') {
                await Future.delayed(Duration(milliseconds: 200), () async {
                  await controller.evaluateJavascript(
                      source:
                          'parent.chgCourse(' + widget.courseId + ', 1, 1)');
                });
                await Future.delayed(Duration(milliseconds: 1000), () async {
                  await webViewController!.loadUrl(
                      urlRequest: URLRequest(
                          url: Uri.parse(
                              "https://eschool.niu.edu.tw/learn/grade/grade_list.php")));
                  setState(() {
                    loadState = true;
                  });
                });
                break;
              } else if (i == 30) {
                globalAdvancedTile = [];
                Navigator.pop(context);
                showToast('網路異常');
                break;
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
                        key: eSchoolGrade,
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
                          if (Provider.of<DarkThemeProvider>(context,
                                  listen: false)
                              .darkTheme) {
                            await controller.evaluateJavascript(source: '''
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(1)").style.backgroundColor = 'rgb(35, 127, 217)';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(2)").style.backgroundColor = 'rgb(35, 127, 217)';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(3)").style.backgroundColor = 'rgb(35, 127, 217)';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(4)").style.backgroundColor = 'rgb(35, 127, 217)';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(5)").style.backgroundColor = 'rgb(35, 127, 217)';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(6)").style.backgroundColor = 'rgb(35, 127, 217)';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(7)").style.backgroundColor = 'rgb(35, 127, 217)';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(8)").style.backgroundColor = 'rgb(35, 127, 217)';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(1) > div").style.color = 'black';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(2) > div").style.color = 'black';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(3) > div").style.color = 'black';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(4) > div").style.color = 'black';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(5) > div").style.color = 'black';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(6) > div").style.color = 'black';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(7) > div").style.color = 'black';
                                  document.querySelector("body > div > div.content > div > div.title-bar > div > table > tbody > tr > td:nth-child(8) > div").style.color = 'black';
                                  ''');
                            await controller.evaluateJavascript(source: '''
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `html {filter: invert(0.90) !important}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `video {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `img {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.image {filter: invert(100%);}`;             
                                  ''');
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
          Navigator.pop(context);
          return false;
        },
        shouldAddCallbacks: true);
  }
}
