import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';

class EventInfoDialog extends StatefulWidget {
  final String eventJS;

  const EventInfoDialog({Key? key, required this.eventJS}) : super(key: key);

  @override
  _EventInfoDialogState createState() => _EventInfoDialogState();
}

class _EventInfoDialogState extends State<EventInfoDialog> {
  HeadlessInAppWebView? headlessWebView;
  bool dataLoaded = false;
  String url = "";
  List data = [];

  void getEventInfo(String js) async {
    data.clear();
    for (int i = 1; i <= 30; i++) {
      await headlessWebView?.webViewController
          .evaluateJavascript(source: widget.eventJS);
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('計時器 $i');

      String? loadState = await headlessWebView?.webViewController
          .evaluateJavascript(
              source:
                  'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply > caption").innerText');

      if (loadState == '活動詳細內容') {
        print('載入完成');

        for (int i = 2;
            await headlessWebView?.webViewController.evaluateJavascript(
                    source:
                        'document.querySelector(\"#ctl00_MainContentPlaceholder_dvGetDetailApply > tbody > tr:nth-child($i) > td:nth-child(1)\")') !=
                null;
            i++) {
          print(i);
          data.add([
            await headlessWebView?.webViewController.evaluateJavascript(
                source:
                    'document.querySelector(\"#ctl00_MainContentPlaceholder_dvGetDetailApply > tbody > tr:nth-child($i) > td:nth-child(1)\").innerText'),
            await headlessWebView?.webViewController.evaluateJavascript(
                source:
                    'document.querySelector(\"#ctl00_MainContentPlaceholder_dvGetDetailApply > tbody > tr:nth-child($i) > td:nth-child(2)\").innerText')
          ]);

          setState(() {
            dataLoaded = true;
          });
        }
        break;
      } else if (i == 30 && loadState == null) {
        print('網路異常，連線超時！');
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    headlessWebView = new HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse("https://syscc.niu.edu.tw/Activity/ApplyList.aspx")),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useOnLoadResource: true,
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
      onLoadResource:
          (InAppWebViewController controller, LoadedResource resource) {
        print(resource.toString());
      },
      onLoadStop: (controller, url) async {
        print("onLoadStop $url");
        getEventInfo(widget.eventJS);
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
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            dataLoaded?
            TextButton(
              onPressed: () {},
              child: Text('報名'),
              style: ButtonStyle(),
            ):SizedBox(),
            Expanded(child: SizedBox()),
            IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: Icon(Icons.close)),
          ],
        ),
        dataLoaded
            ? Expanded(
                child: ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (BuildContext context, int index) => Column(
                          children: [
                            ExpansionTile(
                              key: PageStorageKey(
                                  'event_info' + index.toString()),
                              title: Text(
                                data[index][0],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    data[index][1],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
              )
            : Expanded(
                child: NiuIconLoading(
                  size: 80.0,
                ),
              ),
      ]),
    );
  }
}
