import 'dart:io' as dartCookies;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class TestWebView extends StatefulWidget {
  const TestWebView({
    Key? key,
  }) : super(key: key);

  @override
  _TestWebViewState createState() => new _TestWebViewState();
}

class _TestWebViewState extends State<TestWebView> {
  final GlobalKey testWebView = GlobalKey();
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
    return Container(
      child: Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                    key: testWebView,
                    initialOptions: options,
                    initialUrlRequest: URLRequest(
                        url: Uri.parse("https://browserleaks.com/geo")),
                    onWebViewCreated: (controller) async {
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
                      ].contains(uri.scheme)) {
                        if (await canLaunch(uri.toString())) {
                          await launch(
                            uri.toString(),
                          );
                        }
                        return NavigationActionPolicy.CANCEL;
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      print("onLoadStop $url");
                      setState(() {
                        this.url = url.toString();
                      });
                    },
                    onLoadResource: (InAppWebViewController controller,
                        LoadedResource resource) {},
                    onLoadError: (controller, url, code, message) {},
                    onProgressChanged: (controller, progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
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
                    onScrollChanged:
                        (InAppWebViewController controller, int x, int y) {})
              ],
            ),
          ),
        ])),
      ),
    );
  }
}
