import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/grades/custom_cards.dart';
/*
class FinalPage extends StatefulWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {


  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        ListTile(title:Text("學期平均：$avg \t\t\t 班級排名：$rank")),
        Expanded(
          child: CustomGradeCard(
            key: PageStorageKey<String>('final'),
            grade: grades,
          ),
        ),
      ],
    );
  }
}*/

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
          for (int i = 2; //2~N
              (await controller.evaluateJavascript(
                          source:
                              'document.querySelector("#DataGrid > tbody > tr:nth-child($i)").innerHTML'))
                      .toString() !=
                  'null';
              i++) {
            String lesson = await controller.evaluateJavascript(
                source:
                    'document.querySelector("#DataGrid > tbody > tr:nth-child($i) > td:nth-child(5)").innerText');
            String score = await controller.evaluateJavascript(
                source:
                    'document.querySelector("#DataGrid > tbody > tr:nth-child($i) > td:nth-child(6)").innerText');
            print(lesson);
            print(score);
            grades.add(Quote(lesson: lesson, score: score));
          }
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
    loadStates = false;
    print('final_page dispose');
  }

  @override
  Widget build(BuildContext context) {
    return loadStates
        ? Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                  child: ListTile(
                      title: Text(
                    "班級排名：$rank\n學期平均：$avg",
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ))),
              Expanded(
                child: CustomGradeCard(
                  key: PageStorageKey<String>('final'),
                  grade: grades,
                ),
              ),
            ],
          )
        : NiuIconLoading(size: 80);
  }

  @override
  bool get wantKeepAlive => true;
}
