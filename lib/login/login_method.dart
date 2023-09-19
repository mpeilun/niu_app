import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/e_school/e_school.dart';
import 'package:niu_app/graduation/graduation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class Login {
  String? id;
  String? pwd;

  Login(this.id, this.pwd);

  Login.origin();
  CookieManager cookieManager = CookieManager.instance();

  Future<void> cleanAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveGraduationData = false;
    globalAdvancedTile = [];
    await cookieManager.deleteAllCookies();
    await prefs.clear();
  }

  Future<String> niuLogin() async {
    late String? id;
    late String? pwd;
    final Completer<String> callBack = new Completer<String>();
    if (this.id == null || this.pwd == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getString('id');
      pwd = prefs.getString('pwd');
    } else {
      id = this.id;
      pwd = this.pwd;
    }
    //print('$id $pwd');
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
                source:
                    'document.querySelector("#__VIEWSTATEGENERATOR").value');
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
        onProgressChanged: (controller, progress) {
          print('onProgressChanged:' + progress.toString());
        },
        onJsAlert: (InAppWebViewController controller,
            JsAlertRequest jsAlertRequest) async {
          return JsAlertResponse(
              handledByClient: true, action: JsAlertResponseAction.CONFIRM);
        });

    await headlessWebView.run();

    if (await callBack.future != '') {
      headlessWebView.webViewController
          .loadUrl(urlRequest: URLRequest(url: Uri.parse('about:blank')));
    }
    return callBack.future;
  }

  Future<bool> initNiuLoin(BuildContext context) async {
    String result = await Login.origin()
        .niuLogin()
        .timeout(Duration(seconds: 60), onTimeout: () {
      return '學校系統異常';
    });
    if (result == '登入成功') {
      print('登入成功');
      return true;
    } else if (result == '帳號密碼錯誤') {
      showToast('帳號密碼錯誤，請重新登入');
      Future.delayed(Duration(milliseconds: 3000), () {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(), maintainState: false));
      });
    } else if (result == '學校系統異常') {
      showToast('學校系統異常，請稍後在等開此功能');
      Future.delayed(Duration(milliseconds: 3000), () {
        Navigator.pop(context);
      });
    }
    return false;
  }
}
