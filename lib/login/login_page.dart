import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/external_lib/flutter_login/flutter_login.dart';
import 'package:niu_app/menu/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final bool willPop;

  LoginPage({Key? key, required this.willPop}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  HeadlessInAppWebView? headlessWebView;
  bool loadState = false;
  String loginState = 'null';
  late String url;
  late String id;
  late String pwd;

  Future<String> _authUser(LoginData data) async {
    id = data.name;
    pwd = data.password;
    loginState = 'null';
    await headlessWebView?.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#M_PORTAL_LOGIN_ACNT").value=\'$id\';');
    await headlessWebView?.webViewController.evaluateJavascript(
        source: 'document.querySelector("#M_PW").value=\'$pwd\';');
    await Future.delayed(Duration(milliseconds: 500), () async {
      await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#LGOIN_BTN").click();');
    });
    for (int i = 1; i <= 30; i++) {
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('計時器 $i');
      if (loginState != 'null') {
        break;
      } else if (i == 30 && loginState == 'null') {
        loginState = '網路異常，連線超時！';
        break;
      }
    }
    return loginState;
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
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/Default.aspx') {
            setState(() {
              loadState = true;
            });
          }
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/MainFrame.aspx') {
            print('登入成功');
            loginState = '';
            await _saveData(id, pwd);
          }
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          print("onUpdateVisitedHistory $url");
          setState(() {
            this.url = url.toString();
          });
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
    headlessWebView?.dispose();
    loginState = 'null';
    loadState = false;
    print('login dispose');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return widget.willPop;
        },
        child: Container(
          child: loadState
              ? FlutterLogin(
                  title: '宜大學生 APP',
                  logo: 'assets/niu_logo.png',
                  onLogin: _authUser,
                  hideForgotPasswordButton: true,
                  hideSignUpButton: true,
                  onSubmitAnimationCompleted: () {
                    Navigator.pop(context);
                  },
                  theme: LoginTheme(
                      logoWidth: 0.3, titleStyle: TextStyle(fontSize: 30)),
                  messages: LoginMessages(
                    userHint: '學號',
                    passwordHint: '密碼',
                    loginButton: '登入',
                    flushbarTitleError: '錯誤',
                  ),
                )
              : Loading(),
        ),
      ),
    );
  }

  _saveData(String id, String pwd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id.toLowerCase());
    prefs.setString("pwd", pwd);
  }
}
