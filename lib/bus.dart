import 'dart:convert';
import 'dart:io' as dartCookies;
import 'dart:typed_data';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Bus extends StatefulWidget {
  const Bus({
    Key? key,
  }) : super(key: key);

  @override
  _BusState createState() => new _BusState();
}

class _BusState extends State<Bus> {
  final GlobalKey bus = GlobalKey();
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

  List<String> cleanJs = [
    'document.querySelector(\"#topNav\").style.display=\'none\'',
    'document.querySelector(\"head\").style.display=\'none\'',
    'document.querySelector(\"#main > div.container > nav\").style.display=\'none\'',
    'document.querySelector(\"#main > div.container > div.srch-input\").style.display=\'none\'',
    'document.querySelector(\"#main > div.page-title.page-title-srch\").style.display=\'none\'',
    'document.querySelector(\"#main > a\").style.display=\'none\'',
    'document.querySelector(\"#footer > a\").style.display=\'none\'',
    'document.querySelector(\"#footer > div.footer-info\").style.display=\'none\'',
    'document.querySelector(\"#btnFPMenuOpen\").style.display=\'none\'',
    'document.querySelector(\"#MasterPageBodyTag > a\").style.display=\'none\'',
    'document.querySelector(\"#MasterPageBodyTag > div\").style = \'padding-top: 10px\'',
  ];

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
                          child: NiuIconLoading(size: 80),
                        )),
                    Visibility(
                      visible: loadState,
                      maintainState: true,
                      child: InAppWebView(
                        key: bus,
                        initialUrlRequest: URLRequest(
                            url: Uri.parse(
                                "https://www.taiwanbus.tw/eBUSPage/Query/RouteQuery.aspx?key=%E5%AE%9C%E8%98%AD%E5%A4%A7%E5%AD%B8")),
                        initialOptions: options,
                        onWebViewCreated: (controller) async {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) async {
                          setState(() {
                            this.url = url.toString();
                          });
                          if (url
                              .toString()
                              .contains('https://www.taiwanbus.tw/eBUSPage/')) {
                            setState(() {
                              loadState = false;
                            });
                          }
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
                          ].contains(uri.scheme)) {
                            return NavigationActionPolicy.CANCEL;
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          print("onLoadStop $url");
                          setState(() {
                            this.url = url.toString();
                          });
                          if (url
                              .toString()
                              .contains('www.taiwanbus.tw/eBUSPage/')) {
                            cleanJs.forEach((element) async {
                              await controller.evaluateJavascript(
                                  source: element);
                            });
                            setState(() {
                              loadState = true;
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
                            (controller, url, androidIsReload) {
                          setState(() {
                            this.url = url.toString();
                          });
                          print('onUpdateVisitedHistory:' + url.toString());
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndFloat,
            floatingActionButton: Visibility(
              visible: loadState,
              child: Padding(
                padding: EdgeInsets.only(right: 9, bottom: 50),
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    height: 40,
                    width: 40,
                    child: FloatingActionButton(
                      child: Icon(Icons.home),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          if (progress == 1.0) {
            if (await webViewController!.canGoBack()) {
              webViewController!.goBack();
            } else {
              Navigator.pop(context);
            }
          }
          return false;
        },
        shouldAddCallbacks: true);
  }
}
