import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:niu_app/menu/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final bool cancelPop;
  //true:禁止返回 false:不禁止返回

  LoginPage({Key? key, required this.cancelPop}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  HeadlessInAppWebView? headlessWebView;
  bool loadState = false;
  String loginState = 'null';
  late SharedPreferences prefs;
  late String url;
  late String id;
  late String pwd;
  late String name;
  late int webProgress;

  Future<String> _authUser(LoginData data) async {
    id = data.name;
    pwd = data.password;
    loginState = 'null';
    await jsLogin();
    for (int i = 1; i <= 30; i++) {
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('計時器 $i');
      if (loginState != 'null') {
        break;
      } else if (i == 30 && loginState == 'null') {
        loginState = '網路異常，連線超時！';
        break;
      } else if (i == 5 && webProgress == 100) {
        await headlessWebView?.webViewController.loadUrl(
            urlRequest: URLRequest(
                url: Uri.parse("https://acade.niu.edu.tw/NIU/Default.aspx")));
        print('頁面閒置過長，重新載入');
      } else if (i > 5 && i % 5 == 0 && webProgress == 100) {
        jsLogin();
        print('執行 jsLogin()');
      }
    }
    return loginState;
  }

  jsLogin() async {
    await headlessWebView?.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#M_PORTAL_LOGIN_ACNT").value=\'$id\';');
    await headlessWebView?.webViewController.evaluateJavascript(
        source: 'document.querySelector("#M_PW").value=\'$pwd\';');
    await Future.delayed(Duration(milliseconds: 500), () async {
      await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#LGOIN_BTN").click();');
    });
  }

  @override
  void initState() {
    super.initState();

    headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse("https://acade.niu.edu.tw/NIU/logout.aspx")),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useOnLoadResource: true,
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

          prefs = await SharedPreferences.getInstance();

          if (url.toString() == 'https://acade.niu.edu.tw/NIU/Default.aspx') {
            setState(() {
              loadState = true;
            });
          }
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/MainFrame.aspx') {
            print('登入成功');
            loginState = '';
            name = (await headlessWebView?.webViewController.evaluateJavascript(
                    source:
                        'document.querySelector("#topFrame > frame:nth-child(1)").contentDocument.querySelector("html").querySelector("#form1 > table > tbody > tr > td.title_bg > table > tbody > tr > td:nth-child(4) > span").innerText;'))
                .toString();
            await _saveData(id, pwd, name);
          }
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          print("onUpdateVisitedHistory $url");
          setState(() {
            this.url = url.toString();
          });
        },
        onProgressChanged: (controller, progress) {
          webProgress = progress;
          //print('進度 $webProgress');
        },
        onJsAlert: (InAppWebViewController controller,
            JsAlertRequest jsAlertRequest) async {
          await headlessWebView?.webViewController.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse("https://acade.niu.edu.tw/NIU/Default.aspx")));
          loginState = jsAlertRequest.message!;
          return JsAlertResponse(
              handledByClient: true, action: JsAlertResponseAction.CONFIRM);
        },
        onLoadResource:
            (InAppWebViewController controller, LoadedResource resource) {
          //print(resource.toString());
        });

    headlessWebView?.run();
  }

  @override
  void dispose() {
    super.dispose();
    loginState = 'null';
    loadState = false;
    print('login dispose');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.cancelPop ? () async => false : null,
      child: Container(
        child: loadState
            ? FlutterLogin(
                title: '宜大學生 APP',
                logo: 'assets/niu_logo.png',
                onLogin: _authUser,
                hideForgotPasswordButton: true,
                hideSignUpButton: true,
                onSubmitAnimationCompleted: () {
                  print("id: " + id);
                  print("name: " + name);
                  Navigator.pop(context);
                },
                theme: LoginTheme(
                    logoWidth: 0.35, titleStyle: TextStyle(fontSize: 30)),
                messages: LoginMessages(
                  userHint: '學號',
                  passwordHint: '密碼',
                  loginButton: '登入',
                  flushbarTitleError: '錯誤',
                ),
              )
            : Loading(),
      ),
    );
  }

  _saveData(String id, String pwd, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id.toLowerCase());
    prefs.setString("pwd", pwd);
    prefs.setString("name", name);
  }
}
