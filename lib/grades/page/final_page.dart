import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:NationalIlanUniversityApp/components/niu_icon_loading.dart';
import 'package:NationalIlanUniversityApp/grades/custom_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  HeadlessInAppWebView? headlessWebView;
  bool loadStates = false;
  late String url;
  late int webProgress;
  late List<Quote> grades = [];
  late String rank;
  late String avg;

  @override
  void initState() {
    super.initState();
    headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://acade.niu.edu.tw/NIU/Application/GRD/GRD51/GRD5130_02.aspx"),
            headers: {
              "Referer":
                  "https://acade.niu.edu.tw/NIU/Application/GRD/GRD51/GRD5130_.aspx?progcd=GRD5130"
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
                        "https://acade.niu.edu.tw/NIU/Application/GRD/GRD51/GRD5130_02.aspx"),
                    headers: {
                  "Referer":
                      "https://acade.niu.edu.tw/NIU/Application/GRD/GRD51/GRD5130_.aspx?progcd=GRD5130"
                }));
          }
          if (url.toString() ==
              'https://acade.niu.edu.tw/NIU/Application/GRD/GRD51/GRD5130_02.aspx') {
            avg = await controller.evaluateJavascript(
                source: 'document.querySelector("#Q_CRS_AVG_MARK").innerText');
            rank = await controller.evaluateJavascript(
                source:
                    'document.querySelector("#QTable2 > tbody > tr:nth-child(2) > td:nth-child(2) > table > tbody > tr:nth-child(2) > td:nth-child(4)").innerText');
            rank = '第${rank.replaceAll(RegExp('[^0-9]'), '')}名';
            for (int i = 2; //2~N
                (await controller.evaluateJavascript(
                            source:
                                'document.querySelector("#DataGrid > tbody > tr:nth-child($i)").innerHTML'))
                        .toString() !=
                    'null';
                i++) {
              String type = await controller.evaluateJavascript(
                  source:
                      'document.querySelector("#DataGrid > tbody > tr:nth-child($i) > td:nth-child(4)").innerText');
              String lesson = await controller.evaluateJavascript(
                  source:
                      'document.querySelector("#DataGrid > tbody > tr:nth-child($i) > td:nth-child(5)").innerText');
              String score = await controller.evaluateJavascript(
                  source:
                      'document.querySelector("#DataGrid > tbody > tr:nth-child($i) > td:nth-child(6)").innerText');
              grades.add(Quote(lesson: lesson, score: score, type: type));
            }
            grades.sort((a, b) {
              return a.score!.compareTo(b.score!);
            });
            grades.sort((a, b) {
              if (a.score!.contains('未上傳') || b.score!.contains('未上傳')) {
                return -1;
              } else {
                return double.parse(b.score!).compareTo(double.parse(a.score!));
              }
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
                    url:
                        Uri.parse("https://acade.niu.edu.tw/NIU/logout.aspx")));
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
    print('final_page dispose');
  }

  @override
  Widget build(BuildContext context) {
    return loadStates
        ? CustomFinalCard(
            rank: rank,
            avg: avg,
            grade: grades,
          )
        : NiuIconLoading(size: 80);
  }
}
