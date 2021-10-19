import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/grades/custom_cards.dart';
import 'package:niu_app/login/login_method.dart';
import 'package:niu_app/login/login_page.dart';
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
          javaScriptEnabled: true,
          javaScriptCanOpenWindowsAutomatically: true,
        ),
      ),
      onWebViewCreated: (controller) {
        print('HeadlessInAppWebView created!');
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
        print('onProgressChanged: $progress');
      },
    );

    _checkLoinState();
  }

  @override
  Widget build(BuildContext context) {
    return loadStates
        ? CustomMidCard(
            grade: grades,
          )
        : NiuIconLoading(size: 80);
  }

  Future<void> _checkLoinState() async {
    String result = await Login.origin()
        .niuLogin()
        .timeout(Duration(seconds: 60), onTimeout: () {
      return '學校系統異常';
    });
    if (result == '登入成功') {
      print('登入成功');
      headlessWebView?.run();
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
      showToast('學校系統異常，請重新打開APP');
      Future.delayed(Duration(milliseconds: 3000), () {
        Navigator.pop(context);
      });
    }
  }
}
