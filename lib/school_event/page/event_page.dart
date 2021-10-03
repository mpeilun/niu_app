import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:dio/dio.dart';

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
  List<Event> readTemp = [];
  bool dataLoaded = false;
  bool refreshLoaded = true;

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  Future<void> getData() async {
    readTemp.clear();
    var response = await new Dio().get(
        'https://syscc.niu.edu.tw/Activity/ApplyList.aspx');
    var document = parse(response.data);
    for (int i = 2;
    document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(9)")?.text != null;
        i++) {
      String? status = document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(9)")?.text;
      //if (status != str) continue;
      print(i);
      String? name = document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(4) > div")?.text;
      print(name);
      while(name![name.length-1] =='\n')
        name = name.substring(0, name.length-2);
      String? department = document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(3)")?.text;

      String? signTimeStart =  i > 9
                  ? document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl'+
                      i.toString() +
                      '_lblAttBdate')?.text
                  : document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
                      i.toString() +
          '_lblAttBdate')?.text;

      String? signTimeEnd = i > 9
              ? document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
                  i.toString() +
                  '_lblAttEdate')?.text
              : document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
                  i.toString() +
                  '_lblAttEdate')?.text;

      String? eventTimeStart = i > 9
                  ? document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
                      i.toString() +
                      '_lblActBdate')?.text
                  : document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
                      i.toString() +
                      '_lblActBdate')?.text;

      String? eventTimeEnd = i > 9
              ? document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
                  i.toString() +
                  '_lblActEdate')?.text
              : document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
                  i.toString() +
                  '_lblActEdate')?.text;

      String? positive = i > 9
              ? document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
                  i.toString() +
                  '_lblOKNum')?.text
              : document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
                  i.toString() +
                  '_lblOKNum')?.text;
      String? positiveLimit = i > 9
                  ? document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
                      i.toString() +
                      '_lblLimitNum')?.text
                  : document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
                      i.toString() +
                      '_lblLimitNum')?.text;
      String? wait = i > 9
              ? document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
                  i.toString() +
                  '_lblBKNum')?.text
              : document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
                  i.toString() +
                  '_lblBKNum')?.text;
      String? waitLimit = i > 9
              ? document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
                  i.toString() +
                  '_lblSecNum')?.text
              : document.querySelector('#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
                  i.toString() +
                  '_lblSecNum')?.text;
      String? signUpJavaScript = document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(1) > a")?.outerHtml;
      signUpJavaScript = signUpJavaScript?.substring(signUpJavaScript.indexOf("href=") + 6, signUpJavaScript.indexOf(">") - 1);
      readTemp.add(Event(
        name: name,//活動名稱
        department: department,//主辦部門
        signTimeStart: signTimeStart,//報名時間
        signTimeEnd: signTimeEnd,//報名時間截止
        eventTimeStart: eventTimeStart,//活動時間
        eventTimeEnd: eventTimeEnd,//活動時間截止
        status: status,//報名狀態
        positive: positive,//正取人數
        positiveLimit: positiveLimit,//正取上限
        wait: wait,//備取人數
        waitLimit: waitLimit,//備取上限
        signUpJS: signUpJavaScript, //報名javascript連結
      ));
    }
  }

  Future<void> getDataByStatus (String keyword) async{
    for(int i=0; i<readTemp.length; i++){
      if(readTemp[i].status == keyword){
        data.add(readTemp[i]);
      }
    }
  }

  void getEventList() async {
    data.clear();
    for(int i=1; i<=30; i++){

    }
    await getData();
    await getDataByStatus('報名中');
    await getDataByStatus('已額滿');
    await getDataByStatus('未開放');
    await getDataByStatus('已過期');
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
      initialUrlRequest:
          URLRequest(url: Uri.parse("https://syscc.niu.edu.tw/Activity/ApplyList.aspx")),
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
    return KeepAlivePage(child: buildList());
  }

  Widget buildList() => dataLoaded
      ? RefreshWidget(
          keyRefresh: keyRefresh,
          onRefresh: refresh,
          child: refreshLoaded
              ? CustomEventCard(
                  key: PageStorageKey<String>('event'),
                  data: data,
                )
              : Container(),
        )
      : Center(
          child: NiuIconLoading(
            size: 80.0,
          ),
        );
}
