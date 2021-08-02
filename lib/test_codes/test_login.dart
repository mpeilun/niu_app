import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:niu_app/menu/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  HeadlessInAppWebView? headlessWebView;
  bool loadState = false;
  late String url;
  late String id;
  late String pwd;

  Future<String> _authUser(LoginData data) async {
    id = data.name;
    pwd = data.password;
    await headlessWebView?.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#M_PORTAL_LOGIN_ACNT").value=\'$id\';');
    await headlessWebView?.webViewController.evaluateJavascript(
        source: 'document.querySelector("#M_PW").value=\'$pwd\';');
    await Future.delayed(Duration(milliseconds: 1000), () async {
      await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#LGOIN_BTN").click();');
    });
    return Future.delayed(Duration(milliseconds: 2000), () {
      if (headlessWebView?.webViewController.getUrl().toString() ==
          'https://acade.niu.edu.tw/NIU/MainFrame.aspx') {
        return '登入成功';
      } else {
        return '';
      }
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
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/Default.aspx') {
            setState(() {
              loadState = true;
            });
          }
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/MainFrame.aspx') {
            print('登入成功');
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
          JsAlertResponseAction action =
              await createAlertDialog(context, '帳號或密碼錯誤，請查明後再登入!');
          return JsAlertResponse(handledByClient: true, action: action);
        },
        onLoadResource:
            (InAppWebViewController controller, LoadedResource resource) {
          print(resource.toString());
        });

    headlessWebView?.run();
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
    print('login dispose');
  }

  @override
  Widget build(BuildContext context) {
    return loadState
        ? FlutterLogin(
            title: 'NIU',
            logo: 'assets/niu_logo.png',
            userType: LoginUserType.name,
            onLogin: _authUser,
            hideForgotPasswordButton: true,
            hideSignUpButton: true,
            onSubmitAnimationCompleted: () {
              Navigator.pop(context);
            },
            messages: LoginMessages(
              userHint: 'Number',
              passwordHint: 'Password',
              loginButton: 'LOG IN',
            ),
          )
        : Loading();
  }

  _saveData(String id, String pwd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id.toLowerCase());
    prefs.setString("pwd", pwd);
  }

  Future<JsAlertResponseAction> createAlertDialog(
      BuildContext context, String message) async {
    late JsAlertResponseAction action;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Ok"),
              key: Key("AlertButtonOk"),
              onPressed: () {
                action = JsAlertResponseAction.CONFIRM;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return action;
  }
}
