import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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

  Future<void> getValue() async {
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
      temp.add(Event(
        name: name,
        department: department,
      ));
    }
    await Future.delayed(Duration(seconds: 1));
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
        getValue();
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
          child: CircularProgressIndicator(),
        )
      : RefreshWidget(
          keyRefresh: keyRefresh,
          onRefresh: getValue,
          child: CustomEventCard(
            key: PageStorageKey<String>('event'),
            data: data,
          ),
        );
}
