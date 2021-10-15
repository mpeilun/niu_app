import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' as dartCookies;
import 'dart:typed_data';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';

late DateTime start;
late DateTime end;

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
        useShouldInterceptAjaxRequest: true,
      ),
      android: AndroidInAppWebViewOptions(
        blockNetworkLoads: true,
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          start = DateTime.now();
                          print(await login());
                        },
                        child: Text('登入')),
                  )
                ])),
          ),
        ),
        onWillPop: () async {
          return true;
        },
        shouldAddCallbacks: true);
  }
}

Future<String> login() async {
  String callBack = '';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('id');
  String? pwd = prefs.getString('pwd');
  bool postState = false;
  HeadlessInAppWebView headlessWebView = new HeadlessInAppWebView(
    initialUrlRequest:
        URLRequest(url: Uri.parse("https://acade.niu.edu.tw/NIU/Default.aspx")),
    initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
            // useShouldInterceptAjaxRequest: true,
            ),
        android: AndroidInAppWebViewOptions(
          blockNetworkImage: true,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        )),
    onWebViewCreated: (controller) async {
      print('LoginHeadlessInAppWebView created!');
    },
    onConsoleMessage: (controller, consoleMessage) {
      print("CONSOLE MESSAGE: " + consoleMessage.message);
    },
    onLoadStart: (controller, url) async {
      print("onLoadStart $url");
    },
    onLoadStop: (controller, url) async {
      print("onLoadStop $url");

      if (url.toString() == 'https://acade.niu.edu.tw/NIU/Default.aspx' &&
          postState) {
        var result = await controller.evaluateJavascript(
            source: 'document.body.innerHTML');
        end = DateTime.now();
        if (result.toString().contains('updatePanel|AjaxPanel')) {
          if (!result.toString().contains('alert(\'帳號或密碼錯誤，請查明後再登入!\')')) {
            callBack = '登入成功 耗時:${end.difference(start)}';
          } else {
            callBack = '帳號密碼錯誤 耗時:${end.difference(start)}';
          }
        } else {
          callBack = '網頁異常 耗時:${end.difference(start)}';
        }
      }

      if (url
              .toString()
              .contains('https://acade.niu.edu.tw/NIU/Default.aspx') &&
          !postState) {
        CookieManager().deleteAllCookies();

        var viewState = await controller.evaluateJavascript(
            source: 'document.querySelector("#__VIEWSTATE").value');
        var viewStateGenerator = await controller.evaluateJavascript(
            source: 'document.querySelector("#__VIEWSTATEGENERATOR").value');
        var eventValidation = await controller.evaluateJavascript(
            source: 'document.querySelector("#__EVENTVALIDATION").value');

        while (await controller.evaluateJavascript(
                source: 'document.querySelector("#recaptchaResponse").value') ==
            '') {
          print('recaptchaResponse is null');
          await Future.delayed(Duration(milliseconds: 50), () {});
        }

        var recaptchaResponse = await controller.evaluateJavascript(
            source: 'document.querySelector("#recaptchaResponse").value');

        String formData = 'ScriptManager1=AjaxPanel%7CLGOIN_BTN'
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
            '&LGOIN_BTN.x=0'
            '&LGOIN_BTN.y=0';

        var postData = Uint8List.fromList(utf8.encode(formData));

        controller.postUrl(
            url: Uri.parse("https://acade.niu.edu.tw/NIU/Default.aspx"),
            postData: postData);
        print('postUrl');
        postState = true;
      }
    },
    onLoadError: (InAppWebViewController controller, Uri? url, int code,
        String message) {
      print('onLoadError: url_$url msg_$message');
    },
    onLoadResource:
        (InAppWebViewController controller, LoadedResource resource) {
      print('onLoadResource' + resource.toString());
    },
    onUpdateVisitedHistory: (controller, url, androidIsReload) {},
    onProgressChanged: (controller, progress) {
      print('onProgressChanged:' + progress.toString());
    },
    onJsAlert: (InAppWebViewController controller,
        JsAlertRequest jsAlertRequest) async {
      return JsAlertResponse(
          handledByClient: true, action: JsAlertResponseAction.CONFIRM);
    },
    onAjaxProgress:
        (InAppWebViewController controller, AjaxRequest ajaxRequest) async {
      // log(ajaxRequest.toString());
      return AjaxRequestAction.PROCEED;
    },
    onAjaxReadyStateChange: (controller, ajax) async {
      // log(ajax.toString());
      return AjaxRequestAction.PROCEED;
    },
  );

  await headlessWebView.run();
  while (true) {
    await Future.delayed(Duration(milliseconds: 50), () {});
    if (callBack != '') {
      return callBack;
    }
  }
}
