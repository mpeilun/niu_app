import 'dart:developer';

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

  List<dynamic> data = [];
  List<dynamic> dataCanSignUp = [];
  List<dynamic> dataUnable = [];

  List<dynamic> readTemp = [];
  bool dataLoaded = false;
  bool refreshLoaded = true;

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  Future<void> getData() async {
    readTemp.clear();
    String js = '''javascript:(
function() {
    var data = [];
    var count = document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody").childElementCount + 1;
    for(i = 2; i < count; i++){
        var i_special = i.toString();
        if(i<10){i_special = "0" + i;}
        let name = document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child("+i+") > td:nth-child(4) > div").innerText;
            department = document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child("+i+") > td:nth-child(3)").innerText;
            state = document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child("+i+") > td:nth-child(9)").innerText;
            signTimeStart=document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl"+i_special+"_lblAttBdate").innerText;
            signTimeEnd=document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl"+i_special+"_lblAttEdate").innerText;
            eventTimeStart=document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl"+i_special+"_lblActBdate").innerText;
            eventTimeEnd=document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl"+i_special+"_lblActEdate").innerText;
            positive=document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl"+i_special+"_lblOKNum").innerText;
            positiveLimit=document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl"+i_special+"_lblLimitNum").innerText;
            wait=document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl"+i_special+"_lblBKNum").innerText;
            waitLimit=document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl"+i_special+"_lblSecNum").innerText;
            signUpJs=document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child("+i+") > td:nth-child(1) > a").href;
            eventSerialNum=document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child("+i+") > td:nth-child(2)").innerText;
        data[i-2] = {name,department,state,signTimeStart,signTimeEnd,eventTimeStart,eventTimeEnd,positive,positiveLimit,wait,waitLimit,signUpJs,eventSerialNum};
    }
    return data;
}
)()''';

    readTemp =
        await headlessWebView?.webViewController.evaluateJavascript(source: js);
    log(readTemp.length.toString());
  }

  Future<void> getDataByStatus(String keyword) async {
    for (int i = 0; i < readTemp.length; i++) {
      if (readTemp[i]['state'] == keyword) {
        data.add(readTemp[i]);
      }
    }
  }

  Future<void> dataClassify() async {
    dataCanSignUp.clear();
    dataUnable.clear();
    for (int i = 0; i < data.length; i++) {
      if (data[i]['state'] == '報名中')
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
    //headlessWebView?.webViewController.loadUrl(urlRequest: URLRequest(url: Uri.parse('about:blank')));
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
