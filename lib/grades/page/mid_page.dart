import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/grades/custom_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MidPage extends StatefulWidget {
  const MidPage({Key? key}) : super(key: key);

  @override
  _MidPageState createState() => _MidPageState();
}

class _MidPageState extends State<MidPage> {
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
                "https://acade.niu.edu.tw/NIU/Application/GRD/GRD51/GRD5131_02.aspx"),
            headers: {
              "Referer":
                  "https://acade.niu.edu.tw/NIU/Application/GRD/GRD51/GRD5131_.aspx?progcd=GRD5131"
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
        },
        onLoadStop: (controller, url) async {
          print("onLoadStop $url");
          setState(() {
            this.url = url.toString();
          });
          if (url.toString() ==
              'https://acade.niu.edu.tw/NIU/Application/GRD/GRD51/GRD5131_02.aspx') {
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
              if (type.length < 2) {
                type = '必修';
              }
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
          return JsAlertResponse(
              handledByClient: true, action: JsAlertResponseAction.CONFIRM);
        },
        onAjaxProgress:
            (InAppWebViewController controller, AjaxRequest ajaxRequest) async {
          print('onAjaxProgress:');
          log(ajaxRequest.toString());
          return AjaxRequestAction.PROCEED;
        },
        onAjaxReadyStateChange: (controller, ajax) async {
          print('onAjaxReadyStateChange:');
          log(ajax.toString());
          return AjaxRequestAction.PROCEED;
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
    loadStates = false;
    print('mid_page dispose');
  }

  @override
  Widget build(BuildContext context) {
    return loadStates
        ? CustomMidCard(
            grade: grades,
          )
        : NiuIconLoading(size: 80);
  }
}
