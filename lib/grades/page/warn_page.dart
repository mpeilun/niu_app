import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/grades/custom_cards.dart';
import 'package:niu_app/login/login_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarmPage extends StatefulWidget {
  const WarmPage({Key? key}) : super(key: key);

  @override
  _WarmPageState createState() => _WarmPageState();
}

class _WarmPageState extends State<WarmPage> {
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
            headlessWebView?.webViewController
                .loadUrl(urlRequest: URLRequest(url: Uri.parse('about:blank')));
            setState(() {
              loadStates = true;
            });
          }
        },
        onProgressChanged: (controller, progress) async {
          print('onProgressChanged: $progress');
        });

    _shouldRunWebView();
  }

  @override
  Widget build(BuildContext context) {
    return loadStates
        ? CustomWarnCard(
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

  void _shouldRunWebView() async {
    if (await Login.origin().initNiuLoin(context)) {
      headlessWebView?.run();
    }
  }
}
