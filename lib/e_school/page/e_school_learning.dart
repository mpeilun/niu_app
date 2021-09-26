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

class ESchoolLearning extends StatefulWidget {
  final courseId;
  final List<AdvancedTile> advancedTile;

  const ESchoolLearning({
    Key? key,
    required this.courseId,
    required this.advancedTile,
  }) : super(key: key);

  @override
  _ESchoolLearningState createState() => new _ESchoolLearningState();
}

class _ESchoolLearningState extends State<ESchoolLearning> {
  final GlobalKey eSchoolLearning = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useOnDownloadStart: true,
        useOnLoadResource: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late String url;
  late bool loadState = true;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    if (dartCookies.Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  //parent.chgCourse('10037692', 1, 1,'SYS_04_01_002')
  // https://eschool.niu.edu.tw/learn/grade/grade_list.php
  //https://eschool.niu.edu.tw/learn/path/SCORM_loadCA.php

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
                        key: eSchoolLearning,
                        initialUrlRequest: URLRequest(
                            url: Uri.parse(
                                "https://eschool.niu.edu.tw/learn/index.php")),
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
                              'https://eschool.niu.edu.tw/mooc/login.php') {
                            globalAdvancedTile = [];
                            Navigator.pop(context);
                            showToast('登入逾時，重新登入中！');
                          }
                        },
                        onLoadResource: (InAppWebViewController controller,
                            LoadedResource resource) async {
                          print('onLoadResource: ' + resource.toString());
                          if ((resource.url.toString() ==
                                  'https://eschool.niu.edu.tw/learn/mycourse/index.php' ||
                              resource.url.toString() ==
                                  'https://eschool.niu.edu.tw/forum/m_node_list.php')) {
                            await Future.delayed(Duration(milliseconds: 200),
                                () async {
                              await controller.evaluateJavascript(
                                  source: 'parent.chgCourse(' +
                                      widget.courseId +
                                      ', 1, 1,\'SYS_04_01_002\')');
                            });
                          }
                          if (resource.url.toString() ==
                              'https://eschool.niu.edu.tw/learn/path/SCORM_loadCA.php') {
                            // await Future.delayed(Duration(milliseconds: 1000),
                            //     () async {
                            //   await controller.evaluateJavascript(source: '');
                            // });
                            setState(() {
                              loadState = true;
                            });
                          }
                        },
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
