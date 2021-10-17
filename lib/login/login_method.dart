import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/e_school/e_school.dart';
import 'package:niu_app/graduation/graduation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> cleanAllData() async {
  saveGraduationData = false;
  globalAdvancedTile = [];
  CookieManager().deleteAllCookies();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

class Login {
  String? id;
  String? pwd;

  Login(this.id, this.pwd);

  Future<String> niuLogin() async {
    late String? id;
    late String? pwd;
    final Completer<String> callBack = new Completer<String>();
    if (this.id == '' || this.pwd == '') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getString('id');
      pwd = prefs.getString('pwd');
    } else {
      id = this.id;
      pwd = this.pwd;
    }
    print('$id $pwd');
    DateTime start = DateTime.now();
    bool postState = false;
    HeadlessInAppWebView headlessWebView = new HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse("https://acade.niu.edu.tw/NIU/Default.aspx")),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
            // useShouldInterceptAjaxRequest: true,
            ),
        android: AndroidInAppWebViewOptions(
          blockNetworkImage: true,
        ),
      ),
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
          if (result.toString().contains('updatePanel|AjaxPanel')) {
            if (!result.toString().contains('alert(\'帳號或密碼錯誤，請查明後再登入!\')')) {
              callBack.complete('登入成功');
              print('登入成功 耗時:${DateTime.now().difference(start)}');
            } else {
              callBack.complete('帳號密碼錯誤');
              print('帳號密碼錯誤 耗時:${DateTime.now().difference(start)}');
            }
          } else {
            callBack.complete('學校系統異常');
            print('學校系統異常 耗時:${DateTime.now().difference(start)}');
          }
        }

        if (url
                .toString()
                .contains('https://acade.niu.edu.tw/NIU/Default.aspx') &&
            !postState) {
          var viewState = await controller.evaluateJavascript(
              source: 'document.querySelector("#__VIEWSTATE").value');
          var viewStateGenerator = await controller.evaluateJavascript(
              source: 'document.querySelector("#__VIEWSTATEGENERATOR").value');
          var eventValidation = await controller.evaluateJavascript(
              source: 'document.querySelector("#__EVENTVALIDATION").value');

          DateTime temp = DateTime.now();
          for (int timer = 0; timer <= 30000; timer += 50) {
            print(
                'getRecaptchaResponseTimer Timer:${timer.toString()} milliseconds');
            await Future.delayed(Duration(milliseconds: 50), () {});
            if (await controller.evaluateJavascript(
                    source:
                        'document.querySelector("#recaptchaResponse").value') !=
                '') {
              break;
            } else if (timer == 30000) {
              callBack.complete('學校系統異常');
              break;
            }
          }
          print(
              'receiveRecaptchaResponse 耗時:${DateTime.now().difference(temp)}');

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

    return callBack.future;
  }
}
