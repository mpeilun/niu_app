import 'dart:async';
import 'dart:io' as dartCookies;
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/login/login_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class GraduationDetail extends StatefulWidget {
  const GraduationDetail({
    Key? key,
  }) : super(key: key);

  @override
  _GraduationDetailState createState() => new _GraduationDetailState();
}

class _GraduationDetailState extends State<GraduationDetail> {
  final GlobalKey graduationDetailState = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useOnDownloadStart: true,
    ),
  );

  late String url;
  late bool loadState = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    if (dartCookies.Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }

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
                        key: graduationDetailState,
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
                              !uri.toString().contains("niu.edu.tw")) {
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
                              'https://acade.niu.edu.tw/NIU/Application/ENR/ENRG0/ENRG010_01.aspx') {
                            setState(() {
                              loadState = true;
                            });
                          }
                        },
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
                          print('onUpdateVisitedHistory' + url.toString());
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(
                              'onConsoleMessage:' + consoleMessage.toString());
                          if (consoleMessage.toString().contains(
                              'Uncaught TypeError: Cannot read property \'focus\' of null')) {
                            showToast('無法使用此功能');
                          }
                        },
                        onDownloadStart: (controller, url) async {
                          download(url, context, null);
                        },
                        onJsAlert: (InAppWebViewController controller,
                            JsAlertRequest jsAlertRequest) async {
                          print(jsAlertRequest.message.toString());
                          if (jsAlertRequest.message
                              .toString()
                              .contains('使用時間逾時')) {
                            Navigator.pop(context);
                            showToast('登入逾時，請重新進入');
                          }
                          return JsAlertResponse(
                              handledByClient: true,
                              action: JsAlertResponseAction.CONFIRM);
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
          return true;
        },
        shouldAddCallback: true);
  }

  void _shouldRunWebView() async {
    if (await Login.origin().initNiuLoin(context)) {
      webViewController?.loadUrl(
          urlRequest: URLRequest(
              url: Uri.parse(
                  "https://acade.niu.edu.tw/NIU/Application/ENR/ENRG0/ENRG010_01.aspx"),
              headers: {
            "Referer":
                "https://acade.niu.edu.tw/NIU/Application/ENR/ENRG0/ENRG010_03.aspx"
          }));
    }
  }
}
