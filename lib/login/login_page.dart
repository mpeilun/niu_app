import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String title;
  LoginPage({Key? key, required this.title}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerPWD = TextEditingController();
  HeadlessInAppWebView? headlessWebView;
  bool loadState = false;
  bool hidePassword = true;
  String url = "";
  String id = "";
  String pwd = "";

  void _displayPassword() {
    setState(() {
      this.hidePassword = !this.hidePassword;
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            automaticallyImplyLeading: false),
        body: Column(
          children: <Widget>[
            Visibility(
              visible: !loadState,
              child: Expanded(
                child: Image.network(
                    'https://i.pinimg.com/originals/6b/67/cb/6b67cb8a166c0571c1290f205c513321.gif'),
              ),
            ),
            Visibility(
              visible: loadState,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: TextFormField(
                      controller: _controllerID,
                      onChanged: (String value) async {
                        id = value;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "學號 *",
                        hintText: "輸入您的的學號",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: TextFormField(
                      controller: _controllerPWD,
                      onChanged: (String value) async {
                        pwd = value;
                      },
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            _displayPassword();
                          },
                        ),
                        labelText: "密碼 *",
                        hintText: "預設身分證前八碼",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 52.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 48.0,
                    height: 48.0,
                    child: Visibility(
                      visible: loadState,
                      child: ElevatedButton(
                        child: Text("登入"),
                        onPressed: () async {
                          await login();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  login() async {
    setState(() {
      loadState = false;
    });
    await headlessWebView?.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#M_PORTAL_LOGIN_ACNT").value=\'$id\';');
    await headlessWebView?.webViewController.evaluateJavascript(
        source: 'document.querySelector("#M_PW").value=\'$pwd\';');
    Future.delayed(Duration(seconds: 1), () async {
      await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#LGOIN_BTN").click();');
    });
  }

  _saveData(String id, String pwd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id);
    prefs.setString("pwd", pwd);
    Navigator.pop(context);
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
