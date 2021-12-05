import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventSignedInfoDialog extends StatefulWidget {
  final String js;

  const EventSignedInfoDialog({Key? key, required this.js}) : super(key: key);

  @override
  _EventSignedInfoDialogState createState() => _EventSignedInfoDialogState();
}

class _EventSignedInfoDialogState extends State<EventSignedInfoDialog> {
  final GlobalKey eventInfo = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useOnDownloadStart: true,
        useOnLoadResource: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  double progress = 0;
  bool dataLoaded = false;
  bool buttonClicked = false;
  bool cancelDisable = true;
  String url = '';
  List data = [];
  List cleanJS = [
    'document.querySelector(\"#MainContent\").style = "border-style: none;"',
    'document.querySelector(\"#MainMenu > ul\").style = "visibility: hidden;"',
    'document.querySelector(\"#IMG2\").style = "visibility: hidden;"',
    'document.querySelector(\"#master_content\").style = "visibility: hidden;"',
    'document.querySelector(\"#PageWrapper\").style = "height:  100%; margin: 0px;"',
  ];

  void getEventInfo(String js) async {
    data.clear();
    for (int i = 1; i <= 30; i++) {
      await webViewController!.evaluateJavascript(source: js);
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('計時器 $i');

      String? loadState = await webViewController!.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailSign > caption").innerText');

      if (loadState!.contains('報名資料詳細內容')) {
        print('載入完成');
        cancelDisable = await webViewController!.evaluateJavascript(
            source:
                'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailSign_btnSignDel").disabled');

        for (int i = 2;
            await webViewController!.evaluateJavascript(
                    source:
                        'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailSign > tbody > tr:nth-child($i) > td:nth-child(1)").innerText') !=
                null;
            i++) {
          print(i);
          data.add([
            await webViewController!.evaluateJavascript(
                source:
                    'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailSign > tbody > tr:nth-child($i) > td:nth-child(1)").innerText'),
            ((await webViewController!.evaluateJavascript(
                        source:
                            'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailSign > tbody > tr:nth-child($i) > td:nth-child(2)").innerText'))
                    as String)
                .trim()
          ]);
        }
        setState(() {
          dataLoaded = true;
        });
        break;
      } else if (i == 30) {
        print('網路異常，連線超時！');
        Navigator.pop(context);
        showToast('網路異常 連線逾時');
        break;
      }
    }
  }

  void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? pwd = prefs.getString('pwd');
    await webViewController!.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_rblApplySel_0").click()');
    await webViewController!.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_UserName").value = "$id"');
    await webViewController!.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_Password").value = "$pwd"');
    await webViewController!.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_LoginButton").click()');
  }

  void editEvent() async {
    setState(() {
      dataLoaded = false;
    });
    await webViewController!.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailSign_btnSignEdit").click()');
    for (int i = 1; i <= 30; i++) {
      await Future.delayed(Duration(milliseconds: 1000));
      print('計時器$i');
      String? loadState = await webViewController!.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailSign_Button1").value');
      if (loadState != null) {
        setState(() {
          dataLoaded = true;
        });
        break;
      } else if (i == 30) {
        print('網路異常，連線超時！');
        Navigator.pop(context);
        showToast('連線逾時');
        break;
      }
    }
  }

  void cancelEvent() async {
    setState(() {
      dataLoaded = false;
    });
    await webViewController!.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailSign_btnSignDel").click()');
    await webViewController!.evaluateJavascript(
        source:
            'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailSign_ButtonOk").click()');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            Visibility(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    buttonClicked = true;
                  });
                  editEvent();
                },
                child: Text(
                  '修改資料',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              visible: dataLoaded && !buttonClicked,
            ),
            Visibility(
              child: Container(
                width: 2.0,
                height: 30.0,
                color: Colors.grey.shade200,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
              ),
              visible: dataLoaded && !buttonClicked && !cancelDisable,
            ),
            Visibility(
              child: TextButton(
                onPressed: () {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: '是否要取消報名此活動',
                    desc: '活動名稱:' + data[0][1],
                    buttons: [
                      DialogButton(
                        child: Text(
                          "否",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.pinkAccent,
                      ),
                      DialogButton(
                        child: Text(
                          '是',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () {
                          cancelEvent();
                          setState(() {
                            buttonClicked = true;
                          });
                          Navigator.pop(context);
                        },
                        color: Colors.blueAccent,
                      ),
                    ],
                  ).show();
                },
                child: Text(
                  '取消活動',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              visible: dataLoaded && !buttonClicked && !cancelDisable,
            ),
            Expanded(child: SizedBox()),
            IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: Icon(Icons.close,
                color: Colors.grey,)),
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                key: eventInfo,
                initialOptions: options,
                onWebViewCreated: (controller) async {
                  webViewController = controller;

                  controller.loadUrl(
                      urlRequest: URLRequest(
                          url: Uri.parse(
                              'https://syscc.niu.edu.tw/Activity/MaintainSelPeople.aspx')));
                },
                onLoadStart: (controller, url) async {
                  setState(() {
                    this.url = url.toString();
                  });
                },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;

                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    return NavigationActionPolicy.CANCEL;
                  } //非上述條件，不做任何事
                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  print("onLoadStop $url");
                  setState(() {
                    this.url = url.toString();
                  });
                  if (url.toString().contains(
                      'https://syscc.niu.edu.tw/Activity/MaintainSign/signMaintain.aspx')) {
                    getEventInfo(widget.js);
                  } else {
                    print('TEST LOGINNNNNNNNNNNNNNNNNNNNNNNN');
                    _login();
                  }
                },
                onLoadResource: (InAppWebViewController controller,
                    LoadedResource resource) {},
                onLoadError: (controller, url, code, message) {},
                onProgressChanged: (controller, progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  setState(() {
                    this.url = url.toString();
                  });
                  print('onUpdateVisitedHistory:' + url.toString());
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
                onJsAlert: (InAppWebViewController controller,
                    JsAlertRequest jsAlertRequest) async {
                  showToast(jsAlertRequest.message!);
                  Navigator.pop(context, true);
                  print(jsAlertRequest.message!);
                  print("Logout and Clean cache");
                  return JsAlertResponse(
                      handledByClient: true,
                      action: JsAlertResponseAction.CONFIRM);
                },
              ),
              Visibility(
                visible: !dataLoaded,
                child: NiuIconLoading(
                  size: 80.0,
                ),
              ),
              Visibility(
                visible: dataLoaded && !buttonClicked,
                child: dataLoaded
                    ? Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListView.separated(
                            itemCount: 4,
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(),
                            itemBuilder: (BuildContext context, int index) =>
                                (index == 3)
                                    ? ExpansionTile(
                                        key: PageStorageKey(
                                            'event_signed' + index.toString()),
                                        title: Text(
                                          '其他資料',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        children: [
                                          ListView.separated(
                                              key: PageStorageKey(
                                                  'event_signed_listview_other'),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: data.length - 3,
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      Divider(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      Column(
                                                        children: [
                                                          ListTile(
                                                            leading: Text(
                                                              data[index][0],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            title: Text(
                                                              data[index][1],
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ))
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          ListTile(
                                            leading: Text(
                                              data[index][0],
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            title: Text(
                                              data[index][1],
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
