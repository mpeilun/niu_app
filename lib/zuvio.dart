import 'dart:convert';
import 'dart:io' as dartCookies;
import 'dart:typed_data';

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/geolocator.dart';

class Zuvio extends StatefulWidget {
  const Zuvio({
    Key? key,
  }) : super(key: key);

  @override
  _ZuvioState createState() => new _ZuvioState();
}

class _ZuvioState extends State<Zuvio> {
  final GlobalKey zuvio = GlobalKey();
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
  bool loginState = false;
  bool isExtended = true;
  double progress = 0;
  int scrollY = 0;

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
                          key: zuvio,
                          initialOptions: options,
                          onWebViewCreated: (controller) async {
                            webViewController = controller;

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? id =
                                prefs.getString('id')! + '@ms.niu.edu.tw';
                            String? pwd = prefs.getString('pwd');

                            var postData = Uint8List.fromList(utf8.encode(
                                "email=$id&password=$pwd&current_language=zh-TW"));
                            controller.postUrl(
                                url: Uri.parse(
                                    "https://irs.zuvio.com.tw/irs/submitLogin"),
                                postData: postData);
                          },
                          onLoadStart: (controller, url) async {
                            setState(() {
                              this.url = url.toString();
                            });
                            if (url
                                .toString()
                                .contains('irs.zuvio.com.tw/student5')) {
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
                                ].contains(uri.scheme) ||
                                uri.toString().contains('facebook.com/tr/') ||
                                uri.toString().contains('about:blank')) {
                              return NavigationActionPolicy.CANCEL;
                            } else if (uri.toString().contains('s3.hicloud')) {
                              download(uri, context, null);
                              return NavigationActionPolicy.CANCEL;
                            } else if (loginState == true &&
                                !uri
                                    .toString()
                                    .contains('irs.zuvio.com.tw/student5')) {
                              Alert(
                                closeIcon:
                                    Icon(Icons.close, color: Colors.grey),
                                context: context,
                                type: AlertType.warning,
                                // title: "是否開啟外部連結?",
                                // desc: uri.toString(),
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "是否開啟外部連結？",
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      uri.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "否",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: Colors.pinkAccent,
                                  ),
                                  DialogButton(
                                    child: Text(
                                      "是",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      if (await canLaunch(url)) {
                                        await launch(
                                          url,
                                        );
                                      } else {
                                        Navigator.pop(context);
                                        showToast('無法開啟');
                                      }
                                    },
                                    color: Colors.blueAccent,
                                  ),
                                ],
                              ).show();
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
                                .contains('irs.zuvio.com.tw/student5')) {
                              loginState = true;
                              await controller.evaluateJavascript(
                                  source:
                                      'document.querySelector("#content > div.chicken-pm-chat-box > div.c-pm-c-chat-bottom-wrapper > div.c-pm-c-chat-topic-card-list").style.display = \'none\'');
                              await controller.evaluateJavascript(
                                  source:
                                      'document.querySelector("#content > div.irs-main-page > div.i-m-p-wisdomhall-area").style = \'display: none;\'');
                              await controller.evaluateJavascript(
                                  source:
                                      'document.querySelector("#content > div.private-message-list > div > div.p-m-download-app-box").style = \'display: none;\'');
                              if (Provider.of<DarkThemeProvider>(context,
                                      listen: false)
                                  .darkTheme) {
                                await controller.evaluateJavascript(source: '''
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `html {filter: invert(0.90) !important}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `video {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `img {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.image {filter: invert(100%);}`;
                                  
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.s-i-t-b-wrapper {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.i-c-l-reload-button {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.g-f-button-box {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.i-a-c-q-t-q-b-top-box {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.button {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.i-r-reload-button {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.i-f-f-f-a-post-feedback-button {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.i-m-p-c-a-c-l-c-b-green-block {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.i-m-p-c-a-c-l-c-b-t-star {filter: invert(100%) opacity(80%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.s-i-top-box {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.s-i-t-b-i-b-icon {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.p-m-c-icon-box {filter: invert(100%);}`;
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.user-icon-switch {filter: invert(100%);}`
                                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `div.c-pm-c-chat-wrapper.message-box{filter: invert(100%);}`;
                                  ''');
                              }
                              for (int i = 1; i < 7; i++) {
                                var raw = await controller.evaluateJavascript(
                                    source:
                                        'document.querySelector("#footer > div > div:nth-child($i) > div.g-f-b-b-title").innerText');
                                if (raw.toString().contains('話題') ||
                                    raw.toString().contains('ZOOK') ||
                                    raw.toString().contains('配對')) {
                                  await controller.evaluateJavascript(
                                      source:
                                          'document.querySelector("#footer > div > div:nth-child($i)").style.display=\'none\'');
                                }
                              }
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
                            download(url, context, null);
                          },
                          androidOnGeolocationPermissionsShowPrompt:
                              (InAppWebViewController controller,
                                  String origin) async {
                            print(
                                'androidOnGeolocationPermissionsShowPrompt: $origin');
                            await alertGeolocation(context);
                            return GeolocationPermissionShowPromptResponse(
                                origin: origin, allow: true, retain: true);
                          },
                          onScrollChanged: (InAppWebViewController controller,
                              int x, int y) {
                            // print('onScrollChanged: x:$x y:$y oldY:$scrollY');
                            // if ((y - scrollY) <= 0 && scrollY > 0) {
                            //   setState(() {
                            //     isExtended = false;
                            //   });
                            // } else {
                            //   setState(() {
                            //     isExtended = true;
                            //   });
                            // }
                            // if ((scrollY - y).abs() > 1) {
                            //   scrollY = y;
                            // }
                          }),
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
                padding: EdgeInsets.only(right: 14, bottom: 20),
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
            if ((await webViewController!.evaluateJavascript(
                        source:
                            'document.querySelector("#header > div > div > div.back").align'))
                    .toString() !=
                'null') {
              await webViewController!.evaluateJavascript(
                  source:
                      'document.querySelector("#header > div > div > div.back").click()');
            } else if (url.toString() !=
                'https://irs.zuvio.com.tw/student5/irs/index') {
              await webViewController!.loadUrl(
                  urlRequest: URLRequest(
                      url: Uri.parse(
                          "https://irs.zuvio.com.tw/student5/irs/index")));
            } else {
              Navigator.pop(context);
            }
          }
          return false;
        },
        shouldAddCallbacks: true);
  }
}
