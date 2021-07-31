import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/refresh.dart';
import 'package:niu_app/school_event/custom_cards.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  HeadlessInAppWebView? headlessWebView;
  String url = "";
  String temp = "";

  List<Event> data = [];
  bool canDisplay = false;

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  Future<void> getByStatus(String str) async {
    for (int i = 2;
    await headlessWebView?.webViewController.evaluateJavascript(
        source:
        'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(9)").innerText') != null;
    i++) {
      String status = await headlessWebView?.webViewController
          .evaluateJavascript(
          source:
          'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(9)").innerText');
      if (status != str)
        continue;
      print(i);
      String name = await headlessWebView?.webViewController.evaluateJavascript(
          source:
          'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(4)").innerText');
      String department = await headlessWebView?.webViewController
          .evaluateJavascript(
          source:
          'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(3)").innerText');

      String signTimeStart = await headlessWebView?.webViewController
          .evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblAttBdate").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblAttBdate").innerText');

      String signTimeEnd = await headlessWebView?.webViewController
          .evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblAttEdate").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblAttEdate").innerText');

      String eventTimeStart = await headlessWebView?.webViewController
          .evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblActBdate").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblActBdate").innerText');

      String eventTimeEnd = await headlessWebView?.webViewController
          .evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblActEdate").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblActEdate").innerText');

      String positive = await headlessWebView?.webViewController
          .evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblOKNum").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblOKNum").innerText');
      String positiveLimit = await headlessWebView?.webViewController
          .evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblLimitNum").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblLimitNum").innerText');
      String wait = await headlessWebView?.webViewController.evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblBKNum").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblBKNum").innerText');
      String waitLimit = await headlessWebView?.webViewController
          .evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblSecNum").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblSecNum").innerText');
      data.add(Event(
        name: name,
        department: department,
        signTimeStart: signTimeStart,
        signTimeEnd: signTimeEnd,
        eventTimeStart: eventTimeStart,
        eventTimeEnd: eventTimeEnd,
        status: status,
        positive: positive,
        positiveLimit: positiveLimit,
        wait: wait,
        waitLimit: waitLimit,
      ));
    }
  }

  Future<void> getEventList() async {
    data.clear();
    await getByStatus('報名中');
    await getByStatus('已額滿');
    await getByStatus('未開放');
    await getByStatus('已過期');
    setState(() {
      canDisplay = true;
    });
  }
  Future<void> refresh() async{
    setState(() {
      canDisplay = false;
    });
    await headlessWebView?.webViewController.loadUrl(urlRequest: URLRequest(url: Uri.parse('https://syscc.niu.edu.tw/Activity/ApplyList.aspx')));
    await Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  void initState() {
    super.initState();
    headlessWebView = new HeadlessInAppWebView(
      initialUrlRequest:
      URLRequest(url: Uri.parse("https://syscc.niu.edu.tw/activity/")),
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
    headlessWebView?.dispose();
  }

  @override
  Widget build(BuildContext context) => buildList();

  Widget buildList() =>
      canDisplay
          ? RefreshWidget(
        keyRefresh: keyRefresh,
        onRefresh: refresh,
        child: CustomEventCard(
          key: PageStorageKey<String>('event'),
          data: data,
        ),
      )
          : Center(
        child: NiuIconLoading(
          size: 80.0,
        ),
      );
}
