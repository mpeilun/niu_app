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
  bool loadState = true;
  String url = "";
  String id = "";
  String pwd = "";

  @override
  void initState() {
    super.initState();

    headlessWebView = new HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse("https://acade.niu.edu.tw/NIU/logout.aspx")),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
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
    );

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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: TextFormField(
                  controller: _controllerPWD,
                  onChanged: (String value) async {
                    pwd = value;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.remove_red_eye),
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
    Future.delayed(Duration(seconds: 5), () async {
      setState(() {
        loadState = true;
      });
    });
  }

  _saveData(String id, String pwd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id);
    prefs.setString("pwd", pwd);
    Navigator.pop(context);
  }
}
