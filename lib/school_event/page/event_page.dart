import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/keep_alive.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/refresh.dart';
import 'package:niu_app/school_event/components/event_card.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  HeadlessInAppWebView? headlessWebView;
  String url = "";
  String temp = "";

  List<Event> data = [];
  List<Event> dataCanSignUp = [];
  List<Event> dataUnable = [];

  List<Event> readTemp = [];
  bool dataLoaded = false;
  bool refreshLoaded = true;

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  Future<void> getData() async {
    readTemp.clear();
    for (int i = 2;
        await headlessWebView?.webViewController.evaluateJavascript(
                source:
                    'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(9)").innerText') !=
            null;
        i++) {
      String status = await headlessWebView?.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(9)").innerText');
      //if (status != str) continue;
      String name = ((await headlessWebView?.webViewController.evaluateJavascript(
                  source:
                      'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(4)").innerText'))
              as String)
          .trim();
      String department = await headlessWebView?.webViewController
          .evaluateJavascript(
              source:
                  'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(3)").innerText');

      String signTimeStart = await headlessWebView?.webViewController
          .evaluateJavascript(
              source: 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl${i>9?i:'0$i'}_lblAttBdate").innerText');

      String signTimeEnd = await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl${i>9?i:'0$i'}_lblAttEdate").innerText');

      String eventTimeStart = await headlessWebView?.webViewController
          .evaluateJavascript(
              source: 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl${i>9?i:'0$i'}_lblActBdate").innerText');

      String eventTimeEnd = await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl${i>9?i:'0$i'}_lblActEdate").innerText');

      String positive = await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl${i>9?i:'0$i'}_lblOKNum").innerText');
      String positiveLimit = await headlessWebView?.webViewController
          .evaluateJavascript(
              source: 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl${i>9?i:'0$i'}_lblLimitNum").innerText');
      String wait = await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl${i>9?i:'0$i'}_lblBKNum").innerText');
      String waitLimit = await headlessWebView?.webViewController.evaluateJavascript(
          source: 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl${i>9?i:'0$i'}_lblSecNum").innerText');
      String signUpJavaScript = await headlessWebView?.webViewController
          .evaluateJavascript(
              source:
                  'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(1) > a").href');
      String eventSerialNum = await headlessWebView?.webViewController
          .evaluateJavascript(
              source:
                  'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(2)").innerText');
      print(i);
      readTemp.add(Event(
        name: name,
        //活動名稱
        department: department,
        //主辦部門
        signTimeStart: signTimeStart,
        //報名時間
        signTimeEnd: signTimeEnd,
        //報名時間截止
        eventTimeStart: eventTimeStart,
        //活動時間
        eventTimeEnd: eventTimeEnd,
        //活動時間截止
        status: status,
        //報名狀態
        positive: positive,
        //正取人數
        positiveLimit: positiveLimit,
        //正取上限
        wait: wait,
        //備取人數
        waitLimit: waitLimit,
        //備取上限
        signUpJS: signUpJavaScript, //報名javascript連結
        eventSerialNum: eventSerialNum,//活動編號
      ));
    }
  }

  Future<void> getDataByStatus(String keyword) async {
    for (int i = 0; i < readTemp.length; i++) {
      if (readTemp[i].status == keyword) {
        data.add(readTemp[i]);
      }
    }
  }

  Future<void> dataClassify() async {
    dataCanSignUp.clear();
    dataUnable.clear();
    for (int i = 0; i < data.length; i++) {
      if (data[i].status == '報名中')
        dataCanSignUp.add(data[i]);
      else
        dataUnable.add(data[i]);
    }
  }

  Future<void> getEventList() async {
    data.clear();
    await getData();
    await getDataByStatus('報名中');
    await getDataByStatus('已額滿');
    await getDataByStatus('未開放');
    await getDataByStatus('已過期');
    await dataClassify();
    setState(() {
      dataLoaded = true;
      refreshLoaded = true;
    });
  }

  Future<void> refresh() async {
    setState(() {
      refreshLoaded = false;
    });

    await headlessWebView?.webViewController.loadUrl(
        urlRequest: URLRequest(
            url:
                Uri.parse('https://syscc.niu.edu.tw/Activity/ApplyList.aspx')));
    while (!refreshLoaded) {
      await Future.delayed(Duration(milliseconds: 500));
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
        getEventList();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeepAlivePage(
        child: dataLoaded
            ? RefreshWidget(
                keyRefresh: keyRefresh,
                onRefresh: refresh,
                child: refreshLoaded
                    ? CustomEventCard(
                        key: PageStorageKey<String>('event'),
                        data: data,
                        dataCanSignUp: dataCanSignUp,
                        dataUnable: dataUnable,
                      )
                    : Container(),
              )
            : Center(
                child: NiuIconLoading(
                  size: 80.0,
                ),
              ));
  }
}
