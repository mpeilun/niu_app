import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/graduation/time.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'graduation_page.dart';

class Graduation extends StatefulWidget {
  const Graduation({Key? key}) : super(key: key);

  @override
  _GraduationState createState() => _GraduationState();
}

bool saveGraduationData = false;
late Time globalTime;
late Pass globalPass;

class _GraduationState extends State<Graduation> {
  HeadlessInAppWebView? headlessWebView;
  bool loadStates = false;
  late String url;
  late int webProgress;
  late Time time;
  late Pass pass;

  @override
  void initState() {
    super.initState();
    headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://acade.niu.edu.tw/NIU/Application/ENR/ENRG0/ENRG010_01.aspx"),
            headers: {
              "Referer":
                  "https://acade.niu.edu.tw/NIU/Application/ENR/ENRG0/ENRG010_03.aspx"
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
                        "https://acade.niu.edu.tw/NIU/Application/ENR/ENRG0/ENRG010_01.aspx"),
                    headers: {
                  "Referer":
                      "https://acade.niu.edu.tw/NIU/Application/ENR/ENRG0/ENRG010_03.aspx"
                }));
          }

          if (url.toString() ==
              'https://acade.niu.edu.tw/NIU/Application/ENR/ENRG0/ENRG010_01.aspx') {
            int checkPass(String s) {
              switch (s) {
                case '通過':
                  return 0;
                case '尚未檢測':
                  return 1;
                case '未通過':
                  return 2;
              }

              return 1;
            }

            String raw = await controller.evaluateJavascript(
                source: 'document.querySelector("#div_B").innerHTML');

            String service = raw
                    .split('<br>')[0]
                    .split('　　')[0]
                    .replaceAll(new RegExp(r'[^0-9]'), '') +
                '/' +
                raw
                    .split('<br>')[0]
                    .split('　　')[1]
                    .replaceAll(new RegExp(r'[^0-9]'), '');
            String multiple = raw
                    .split('<br>')[1]
                    .split('　　')[0]
                    .replaceAll(new RegExp(r'[^0-9]'), '') +
                '/' +
                raw
                    .split('<br>')[1]
                    .split('　　')[1]
                    .replaceAll(new RegExp(r'[^0-9]'), '');
            String profession = raw
                    .split('<br>')[2]
                    .split('　　')[0]
                    .replaceAll(new RegExp(r'[^0-9]'), '') +
                '/' +
                raw
                    .split('<br>')[2]
                    .split('　　')[1]
                    .replaceAll(new RegExp(r'[^0-9]'), '');
            String flex = raw
                    .split('<br>')[3]
                    .split('　　')[0]
                    .replaceAll(new RegExp(r'[^0-9]'), '') +
                '/' +
                raw
                    .split('<br>')[3]
                    .split('　　')[1]
                    .replaceAll(new RegExp(r'[^0-9]'), '');

            int english = checkPass(await controller.evaluateJavascript(
                source: 'document.querySelector("#div_D").innerText'));
            int physical = checkPass(await controller.evaluateJavascript(
                source: 'document.querySelector("#div_C").innerText'));

            String credit = await controller.evaluateJavascript(
                    source:
                        'document.querySelector("#DataGrid_CRD > tbody > tr:nth-child(7) > td:nth-child(3)").innerText') +
                '/' +
                await controller.evaluateJavascript(
                    source:
                        'document.querySelector("#DataGrid_CRD > tbody > tr:nth-child(7) > td:nth-child(2)").innerText');

            print(
                '$service $multiple $profession $flex $english $physical $credit');

            time = Time(
                service: service,
                multiple: multiple,
                profession: profession,
                flex: flex);
            pass = Pass(english: english, physical: physical, credit: credit);

            globalTime = time;
            globalPass = pass;
            saveGraduationData = true;

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

    if (saveGraduationData) {
      setState(() {
        loadStates = true;
      });
    } else {
      headlessWebView?.run();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loadStates
        ? GraduationPage(time: globalTime, pass: globalPass)
        : NiuIconLoading(size: 80);
  }
}