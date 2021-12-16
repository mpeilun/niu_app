import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/keep_alive.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/refresh.dart';
import 'package:niu_app/provider/event_signed_refresh_provider.dart';
import 'package:niu_app/school_event/components/event_signed_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventSignedPage extends StatefulWidget {
  const EventSignedPage({Key? key}) : super(key: key);

  @override
  _EventSignedPageState createState() => _EventSignedPageState();
}

class _EventSignedPageState extends State<EventSignedPage> {
  HeadlessInAppWebView? headlessWebView;
  String url = "";
  bool dataLoaded = false;
  bool refreshLoaded = true;
  List<EventSigned> tmp = [];

  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  late final signedListChange =
      Provider.of<EventSignedRefreshProvider>(context);



  Future<void> _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? pwd = prefs.getString('pwd');
    await headlessWebView?.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_rblApplySel_0").click()');
    await headlessWebView?.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_UserName").value = "$id"');
    await headlessWebView?.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_Password").value = "$pwd"');
    await headlessWebView?.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_LoginButton").click()');

    print(await headlessWebView?.webViewController
        .evaluateJavascript(source: 'document.querySelector("html")'));
  }

  Future<void> getEventSignedList() async {
    tmp.clear();
    var end = await headlessWebView?.webViewController.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign > tbody").childElementCount');
    for (int i = 2; i < end; i++) {
      print(i);
      String name = ((await headlessWebView?.webViewController.evaluateJavascript(
                  source:
                      'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign > tbody > tr:nth-child($i) > td:nth-child(4)").innerText'))
              as String)
          .trim();
      String status = await headlessWebView?.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign > tbody > tr:nth-child($i) > td:nth-child(2)").innerText');
      if (status == ' ') status = '未知';
      String signedStatus = await headlessWebView?.webViewController
          .evaluateJavascript(
              source:
                  'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign > tbody > tr:nth-child($i) > td:nth-child(3)").innerText');
      String eventTimeStart = await headlessWebView?.webViewController
          .evaluateJavascript(
              source: i > 9
                  ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign_ctl' +
                      i.toString() +
                      '_lblActBdate").innerText'
                  : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign_ctl0' +
                      i.toString() +
                      '_lblActBdate").innerText');
      String eventTimeEnd = await headlessWebView?.webViewController.evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign_ctl' +
                  i.toString() +
                  '_lblActEdate").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign_ctl0' +
                  i.toString() +
                  '_lblActEdate").innerText');

      String signTime = await headlessWebView?.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign > tbody > tr:nth-child($i) > td:nth-child(6)").innerText');

      String js = await headlessWebView?.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign > tbody > tr:nth-child($i) > td:nth-child(1) > a").href');
      tmp.add(EventSigned(
        name: name,
        eventTimeStart: eventTimeStart,
        eventTimeEnd: eventTimeEnd,
        status: status,
        signTime: signTime,
        signedStatus: signedStatus,
        js: js,
      ));
    }
    signedListChange.setData(tmp);

    dataLoaded = true;
    refreshLoaded = true;
  }

  Future<void> refresh() async {
    refreshLoaded = false;
    await headlessWebView?.webViewController.loadUrl(
        urlRequest: URLRequest(
            url: Uri.parse(
                'https://syscc.niu.edu.tw/Activity/MaintainSelPeople.aspx')));
    while (!refreshLoaded) {
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  @override
  void initState() {
    super.initState();
    headlessWebView = new HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse(
              "https://syscc.niu.edu.tw/Activity/MaintainSelPeople.aspx")),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(),
      ),
      onWebViewCreated: (controller) {
        print('HeadlessInAppWebView created!');
      },
      onConsoleMessage: (controller, consoleMessage) {
        print("CONSOLE MESSAGE: " + consoleMessage.message);
      },
      onLoadStart: (controller, url) async {
        print("onLoadStart $url");
        this.url = url.toString();
      },
      onLoadStop: (controller, url) async {
        print("onLoadStop $url");
        if (url.toString().contains(
            'https://syscc.niu.edu.tw/Activity/MaintainSign/signMaintain.aspx')) {
          print('Hello');
          print(await headlessWebView?.webViewController.evaluateJavascript(
              source: 'document.querySelector("body").innerHTML'));
          await getEventSignedList();
        } else {
          print('TEST LOGINNNNNNNNNNNNNNNNNNNNNNNN');
          _login();
        }
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {
        print("onUpdateVisitedHistory $url");
        this.url = url.toString();
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
    if (signedListChange.data.isEmpty) {
      print('需要刷新－－－－－－－－－－－－');
      refresh();
    }
    return KeepAlivePage(
      child: dataLoaded
            ? RefreshWidget(
        keyRefresh: keyRefresh,
        onRefresh: refresh,
        child: refreshLoaded
            ? CustomEventSignedCard(
          key: PageStorageKey<String>('event_signed'),
          data: signedListChange.data,
        )
            : Container())
          : Container(
              child: Column(
                children: [
                  Expanded(child: NiuIconLoading(size: 80)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      '僅顯示前15筆報名資料',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            )
    );
  }
}
