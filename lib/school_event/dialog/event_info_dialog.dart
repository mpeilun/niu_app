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
  
  Future<void> getEventInfo(String js) async{
    for (int i = 1; i <= 30; i++) {
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('計時器 $i');
      if (headlessWebView?.webViewController.evaluateJavascript(source: 'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply > caption")') != 'null') {
        break;
      } else if (i == 30 && loginState == 'null') {
        loginState = '網路異常，連線超時！';
        break;
      } else if (i == 5 && webProgress == 100) {
        await headlessWebView?.webViewController.loadUrl(
            urlRequest: URLRequest(
                url: Uri.parse("https://acade.niu.edu.tw/NIU/Default.aspx")));
        print('頁面閒置過長，重新載入');
      } else if (i > 5 && i % 5 == 0 && webProgress == 100) {
        jsLogin();
        print('執行 jsLogin()');
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
            TextButton(
              onPressed: () {
              },
              child: Text('報名'),
              style: ButtonStyle(),
            ),
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
                    itemCount: 1,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (BuildContext context, int index) => Column(
                          children: [
                            ExpansionTile(
                              key: PageStorageKey(
                                  'event_info' + index.toString()),
                              title: Text(
                                '　詳細資料',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
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
