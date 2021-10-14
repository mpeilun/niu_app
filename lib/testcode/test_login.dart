import 'dart:convert';
import 'dart:developer';
import 'dart:io' as dartCookies;
import 'dart:typed_data';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';

class TestLoginWebView extends StatefulWidget {
  const TestLoginWebView({
    Key? key,
  }) : super(key: key);

  @override
  _TestLoginWebViewState createState() => new _TestLoginWebViewState();
}

class _TestLoginWebViewState extends State<TestLoginWebView> {
  final GlobalKey testLoginWebViewState = GlobalKey();
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
  double progress = 0;
  bool postState = false;

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
                    InAppWebView(
                      key: testLoginWebViewState,
                      initialUrlRequest: URLRequest(
                          url: Uri.parse(
                              "https://acade.niu.edu.tw/NIU/Default.aspx")),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          javaScriptCanOpenWindowsAutomatically: true,
                          useShouldInterceptAjaxRequest: true,
                        ),
                      ),
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

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        print("onLoadStop $url");
                        setState(() {
                          this.url = url.toString();
                        });
                        if (url.toString().contains(
                                'https://acade.niu.edu.tw/NIU/Default.aspx') &&
                            !postState) {
                          CookieManager().deleteAllCookies();

                          String id = 'b0943034';
                          String pwd = 'a1309237';

                          var viewState = await controller.evaluateJavascript(
                              source:
                                  'document.querySelector("#__VIEWSTATE").value');
                          var viewStateGenerator =
                              await controller.evaluateJavascript(
                                  source:
                                      'document.querySelector("#__VIEWSTATEGENERATOR").value');
                          var eventValidation = await controller.evaluateJavascript(
                              source:
                                  'document.querySelector("#__EVENTVALIDATION").value');

                          while (await controller.evaluateJavascript(
                                  source:
                                      'document.querySelector("#recaptchaResponse").value') ==
                              '') {
                            await Future.delayed(
                                Duration(milliseconds: 1000), () {});
                            print('recaptchaResponse is null');
                          }

                          var recaptchaResponse =
                              await controller.evaluateJavascript(
                                  source:
                                      'document.querySelector("#recaptchaResponse").value');

                          String formData =
                              'ScriptManager1=AjaxPanel%7CLGOIN_BTN'
                              '&__EVENTTARGET='
                              '&__EVENTARGUMENT='
                              '&__VIEWSTATE=${Uri.encodeComponent(viewState)}'
                              '&__VIEWSTATEGENERATOR=${Uri.encodeComponent(viewStateGenerator)}'
                              '&__VIEWSTATEENCRYPTED='
                              '&__EVENTVALIDATION=${Uri.encodeComponent(eventValidation)}'
                              '&M_PORTAL_LOGIN_ACNT=$id'
                              '&M_PW=$pwd'
                              '&recaptchaResponse=${Uri.encodeComponent(recaptchaResponse)}'
                              '&__ASYNCPOST=true'
                              '&LGOIN_BTN.x=64'
                              '&LGOIN_BTN.y=25';

                          print('------test--------');
                          print(await controller.evaluateJavascript(
                              source:
                                  'document.querySelector("#recaptchaResponse").value'));
                          print('------test--------');
                          log(formData);

                          var postData =
                              Uint8List.fromList(utf8.encode(formData));

                          controller.postUrl(
                              url: Uri.parse(
                                  "https://acade.niu.edu.tw/NIU/Default.aspx"),
                              postData: postData);
                          postState = true;
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
                      onAjaxProgress: (InAppWebViewController controller,
                          AjaxRequest ajaxRequest) async {
                        log('ajax progress: $ajaxRequest');
                        print('');
                        return AjaxRequestAction.PROCEED;
                      },
                      onAjaxReadyStateChange: (controller, ajax) async {
                        log('onAjaxReadyStateChange: $ajax');
                        // print('AJAX RESPONSE TEXT: ' + ajax.responseText.toString());
                        print('');
                        return AjaxRequestAction.PROCEED;
                      },
                    )
                  ],
                ),
              ),
            ])),
          ),
        ),
        onWillPop: () async {
          return true;
        },
        shouldAddCallbacks: true);
  }
}
