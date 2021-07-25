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

class _EventPageState extends State<EventPage> {
  HeadlessInAppWebView? headlessWebView;
  String url = "";
  String temp = "";

  List<Event> data = [];

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  Future<void> getEventList() async {
    List<Event> temp = [];
    for (int i = 2;
        await headlessWebView?.webViewController.evaluateJavascript(
                source:
                    'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(4)").innerText') !=
            null;
        i++) {
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

      String  positive= await headlessWebView?.webViewController
          .evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblOKNum").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblOKNum").innerText');
      String  positiveLimit= await headlessWebView?.webViewController
          .evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblLimitNum").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblLimitNum").innerText');
      String  wait= await headlessWebView?.webViewController
          .evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblBKNum").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblBKNum").innerText');
      String  waitLimit= await headlessWebView?.webViewController
          .evaluateJavascript(
          source: i > 9
              ? 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl' +
              i.toString() +
              '_lblSecNum").innerText'
              : 'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply_ctl0' +
              i.toString() +
              '_lblSecNum").innerText');

      String status = await headlessWebView?.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_gvGetApply > tbody > tr:nth-child($i) > td:nth-child(9)").innerText');
      temp.add(Event(
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
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      this.data = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    headlessWebView = new HeadlessInAppWebView(
      initialUrlRequest:
          URLRequest(url: Uri.parse("https://syscc.niu.edu.tw/activity/")),
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
        setState(() {
          this.url = url.toString();
        });
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

  Widget buildList() => data.isEmpty
      ? Center(
          child: NiuIconLoading(
            size: 80.0,
          ),
        )
      : RefreshWidget(
          keyRefresh: keyRefresh,
          onRefresh: getEventList,
          child: CustomEventCard(
            key: PageStorageKey<String>('event'),
            data: data,
          ),
        );
}
