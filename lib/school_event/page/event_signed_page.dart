import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/refresh.dart';
import 'package:niu_app/school_event/custom_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventSignedPage extends StatefulWidget {
  const EventSignedPage({Key? key}) : super(key: key);

  @override
  _EventSignedPageState createState() => _EventSignedPageState();
}

class _EventSignedPageState extends State<EventSignedPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  HeadlessInAppWebView? headlessWebView;
  String url = "";

  List<EventSigned> data = [];

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

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
    List<EventSigned> temp = [];
    for (int i = 2;
        await headlessWebView?.webViewController.evaluateJavascript(
                source:
                    'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign > tbody > tr:nth-child($i) > td:nth-child(4)").innerText') !=
            null;
        i++) {
      print(i);
      String name = await headlessWebView?.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign > tbody > tr:nth-child($i) > td:nth-child(4)").innerText');
      String status = await headlessWebView?.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_gvGetSign > tbody > tr:nth-child($i) > td:nth-child(2)").innerText');
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
      temp.add(EventSigned(
        name: name,
        eventTimeStart: eventTimeStart,
        eventTimeEnd: eventTimeEnd,
        status: status,
        signTime: signTime,
        signedStatus: signedStatus,
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
        setState(() {
          this.url = url.toString();
        });
      },
      onLoadStop: (controller, url) async {
        print("onLoadStop $url");
        if (url.toString().contains(
            'https://syscc.niu.edu.tw/Activity/MaintainSign/signMaintain.aspx')) {
          print('Hello');
          print(await headlessWebView?.webViewController.evaluateJavascript(
              source: 'document.querySelector("body").innerHTML'));
          getEventSignedList();
        } else {
          print('TEST LOGINNNNNNNNNNNNNNNNNNNNNNNN');
          _login();
        }
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
  Widget build(BuildContext context) {
    super.build(context);
    return buildList();
  }

  Widget buildList() => data.isEmpty
      ? Center(
          child: NiuIconLoading(
            size: 80.0,
          ),
        )
      : CustomEventSignedCard(
          key: PageStorageKey<String>('event'),
          data: data,
        );
}
