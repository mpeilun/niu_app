import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/e_school/advanced_tiles.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WorkPage extends StatefulWidget {
  final String semester;

  const WorkPage({Key? key, required this.semester}) : super(key: key);

  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  HeadlessInAppWebView? headlessWebView;
  bool loadStates = false;
  late String url;
  late List<AdvancedTile> advancedTile = [];

  @override
  void initState() {
    super.initState();
    headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse("https://eschool.niu.edu.tw/learn/my_homework.php"),
        ),
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
          if (url.toString() ==
              'https://eschool.niu.edu.tw/learn/my_homework.php') {
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
          if (url.toString() ==
              'https://eschool.niu.edu.tw/learn/my_homework.php') {
            for (int i = 1;
                await headlessWebView?.webViewController.evaluateJavascript(
                        source:
                            'document.querySelector("body > div > div.content > div > div.content > div > table > tbody > tr:nth-child(' +
                                i.toString() +
                                ') > td:nth-child(2) > div").innerText') !=
                    null;
                i++) {
              if ((await headlessWebView?.webViewController.evaluateJavascript(
                              source:
                                  'document.querySelector("body > div > div.content > div > div.content > div > table > tbody > tr:nth-child(' +
                                      i.toString() +
                                      ') > td:nth-child(2) > div").innerText')
                          as String)
                      .split('_')[0] ==
                  widget.semester) {
                String courseName = (await headlessWebView?.webViewController
                            .evaluateJavascript(
                                source:
                                    'document.querySelector("body > div > div.content > div > div.content > div > table > tbody > tr:nth-child(' +
                                        i.toString() +
                                        ') > td:nth-child(2) > div").innerText')
                        as String)
                    .split('_')[1]
                    .split('(')[0];
                String courseId = await headlessWebView?.webViewController
                    .evaluateJavascript(
                        source:
                            'document.querySelector("body > div > div.content > div > div.content > div > table > tbody > tr:nth-child(' +
                                i.toString() +
                                ') > td:nth-child(1) > div").innerText') as String;
                String workCount = await headlessWebView?.webViewController
                    .evaluateJavascript(
                        source:
                            'document.querySelector("body > div > div.content > div > div.content > div > table > tbody > tr:nth-child(' +
                                i.toString() +
                                ') > td:nth-child(3) > div").innerText') as String;
                String submitCount = await headlessWebView?.webViewController
                    .evaluateJavascript(
                        source:
                            'document.querySelector("body > div > div.content > div > div.content > div > table > tbody > tr:nth-child(' +
                                i.toString() +
                                ') > td:nth-child(4) > div").innerText') as String;
                advancedTile.add(AdvancedTile(
                    title: courseName,
                    courseId: courseId,
                    workCount: workCount,
                    submitCount: submitCount));
              }
            }
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
        onProgressChanged: (controller, progress) async {},
        onJsAlert: (InAppWebViewController controller,
            JsAlertRequest jsAlertRequest) async {
          print(jsAlertRequest.message.toString());
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
  }

  @override
  Widget build(BuildContext context) {
    return loadStates
        ? CustomWorkCard(tile: advancedTile)
        : NiuIconLoading(size: 80);
  }
}

class CustomWorkCard extends StatefulWidget {
  const CustomWorkCard({
    Key? key,
    required this.tile,
  }) : super(key: key);

  final List<AdvancedTile> tile;

  @override
  _CustomWorkCardState createState() => _CustomWorkCardState();
}

class _CustomWorkCardState extends State<CustomWorkCard> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      //controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.tile.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 8,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        double workCount = double.parse('${widget.tile[index].workCount}');
        double submitCount = double.parse('${widget.tile[index].workCount}') -
            double.parse('${widget.tile[index].submitCount}');
        bool isFinish = false;
        bool isZero = false;
        if (submitCount == workCount) {
          isFinish = true;
        }
        if (workCount == 0) {
          isZero = true;
        }
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          elevation: 1.5,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.tile[index].title}',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Tooltip(
                      showDuration: Duration(milliseconds: 500),
                      message: '前往作業繳交區',
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            minimumSize: Size(0.0, 0.0),
                          ),
                          child: Text("Go!",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                          onPressed: () => null),
                    ),
                  ],
                ),
                LinearPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  lineHeight: 20.0,
                  leading: Text(
                    "繳交進度",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Container(
                    width: 48.0,
                    child: Text(
                      "${submitCount.toStringAsFixed(0)}/${workCount.toStringAsFixed(0)}",
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  percent: isZero ? 1 : submitCount / workCount,
                  center: Text(
                    isZero
                        ? "沒有作業"
                        : "${(submitCount / workCount * 100).toStringAsFixed(2)}%",
                    textAlign: TextAlign.center,
                  ),
                  linearStrokeCap: LinearStrokeCap.butt,
                  progressColor: isFinish ? Colors.greenAccent : Colors.amber,
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
