import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/grades/custom_cards.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage>
    with AutomaticKeepAliveClientMixin<FinalPage> {
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
        },
        onLoadStop: (controller, url) async {
          print("onLoadStop $url");
          setState(() {
            this.url = url.toString();
          });
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
          print('onJsAlert ' + jsAlertRequest.message.toString());
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return loadStates
        ? Column(
            children: [
              Container(
                  color: Theme.of(context).primaryColor,
                  child: ExpansionTile(
                    title: Text(
                      "班級排名：$rank",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 12.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "期末平均：$avg",
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: CustomGradeCard(
                  grade: grades,
                ),
              ),
            ],
          )
        : NiuIconLoading(size: 80);
  }
}
