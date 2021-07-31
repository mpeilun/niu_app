import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/grades/custom_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarmPage extends StatefulWidget {
  const WarmPage({Key? key}) : super(key: key);

  @override
  _WarmPageState createState() => _WarmPageState();
}

class _WarmPageState extends State<WarmPage>
    with AutomaticKeepAliveClientMixin<WarmPage> {
  HeadlessInAppWebView? headlessWebView;
  bool loadStates = false;
  late String url;
  late int webProgress;
  List<Quote> grades = [];

  @override
  void initState() {
    super.initState();
    headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://acade.niu.edu.tw/NIU/Application/GRD/GRD30/GRD3060_02.aspx"),
            headers: {
              "Referer":
                  "https://acade.niu.edu.tw/NIU/Application/GRD/GRD30/GRD3060_.aspx?progcd=GRD3060"
            }),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useOnLoadResource: true,
            useShouldInterceptAjaxRequest: true,
            javaScriptEnabled: true,
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
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/Default.aspx') {
            setState(() {
              loadStates = false;
            });
          }
        },
        onLoadStop: (controller, url) async {
          print("onLoadStop $url");
          setState(() {
            this.url = url.toString();
          });
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/Default.aspx') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? id = prefs.getString('id');
            String? pwd = prefs.getString('pwd');
            await headlessWebView?.webViewController.evaluateJavascript(
                source:
                    'document.querySelector("#M_PORTAL_LOGIN_ACNT").value=\'$id\';');
            await headlessWebView?.webViewController.evaluateJavascript(
                source: 'document.querySelector("#M_PW").value=\'$pwd\';');
            Future.delayed(Duration(milliseconds: 1000), () async {
              await headlessWebView?.webViewController.evaluateJavascript(
                  source: 'document.querySelector("#LGOIN_BTN").click();');
            });
          }
          if (url.toString() == 'https://acade.niu.edu.tw/NIU/MainFrame.aspx') {
            await headlessWebView?.webViewController.loadUrl(
                urlRequest: URLRequest(
                    url: Uri.parse(
                        "https://acade.niu.edu.tw/NIU/Application/GRD/GRD30/GRD3060_02.aspx"),
                    headers: {
                  "Referer":
                      "https://acade.niu.edu.tw/NIU/Application/GRD/GRD30/GRD3060_.aspx?progcd=GRD3060"
                }));
          }
          if (url.toString() ==
              'https://acade.niu.edu.tw/NIU/Application/GRD/GRD30/GRD3060_02.aspx') {
            for (int i = 2; //2~N
                (await controller.evaluateJavascript(
                            source:
                                'document.querySelector("#DataGrid > tbody > tr:nth-child($i)").innerHTML'))
                        .toString() !=
                    'null';
                i++) {
              String lesson = await controller.evaluateJavascript(
                  source:
                      'document.querySelector("#DataGrid > tbody > tr:nth-child($i) > td:nth-child(4)").innerText');
              String teacher = await controller.evaluateJavascript(
                  source:
                      'document.querySelector("#DataGrid > tbody > tr:nth-child($i) > td:nth-child(3)").innerText');
              bool warn = false;
              bool gradeWarn = false;
              bool attendanceWarn = false;
              bool presentWarn = false;
              if (await controller.evaluateJavascript(
                      source:
                          'document.querySelector("#DataGrid > tbody > tr:nth-child($i) > td:nth-child(5)").innerText') ==
                  '是') {
                warn = true;
                if (await controller.evaluateJavascript(
                        source:
                            'document.querySelector("#DataGrid_ctl${i}_IS_WARYING").checked)') ==
                    true) {
                  gradeWarn = true;
                }
                if (await controller.evaluateJavascript(
                        source:
                            'document.querySelector("#DataGrid_ctl${i}_IS_ATTEND").checked') ==
                    true) {
                  attendanceWarn = true;
                }
                if (await controller.evaluateJavascript(
                        source:
                            'document.querySelector("#DataGrid_ctl${i}_IS_ASSESS").checked') ==
                    true) {
                  presentWarn = true;
                }
              }
              grades.add(Quote(
                  lesson: lesson,
                  teacher: teacher,
                  warn: warn,
                  gradeWarn: gradeWarn,
                  attendanceWarn: attendanceWarn,
                  presentWarn: presentWarn));
            }
            grades.sort((a, b) {
              if (b.warn!) {
                return 1;
              }
              return -1;
            });
            setState(() {
              loadStates = true;
            });
          }
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          print("onUpdateVisitedHistory $url");
          setState(() {
            this.url = url.toString();
          });
        },
        onProgressChanged: (controller, progress) async {
          setState(() {
            webProgress = progress;
          });
        },
        onJsAlert: (InAppWebViewController controller,
            JsAlertRequest jsAlertRequest) async {
          print(jsAlertRequest.message.toString());
          if (jsAlertRequest.message.toString().contains('使用時間逾時')) {
            await headlessWebView?.webViewController.loadUrl(
                urlRequest: URLRequest(
                    url: Uri.parse(
                        "https://acade.niu.edu.tw/NIU/Default.aspx")));
          }
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
    loadStates = false;
    print('warn_page dispose');
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return loadStates
        ? CustomWarnCard(
            keyName: 'warm',
            grade: grades,
          )
        : Container(
            child: Column(
              children: [
                Expanded(child: NiuIconLoading(size: 80)),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    '此頁面載入時間較長，請耐心等候',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
