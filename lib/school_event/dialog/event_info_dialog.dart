import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventInfoDialog extends StatefulWidget {
  final String eventJS;

  const EventInfoDialog({Key? key, required this.eventJS}) : super(key: key);

  @override
  _EventInfoDialogState createState() => _EventInfoDialogState();
}

class _EventInfoDialogState extends State<EventInfoDialog> {
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
  bool signUpClicked = false;
  double opacity = 0.5;
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
      setState(() {
        opacity = 0.5;
      });
      await webViewController!.evaluateJavascript(source: js);
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('計時器 $i');

      String? loadState = await webViewController!.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply > caption").innerText');

      if (loadState == '活動詳細內容') {
        print('載入完成');
        setState(() {
          opacity = 0;
        });

        for (int i = 2;
            await webViewController!.evaluateJavascript(
                    source:
                        'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply > tbody > tr:nth-child($i) > td:nth-child(1)").innerText') !=
                null;
            i++) {
          print(i);
          data.add([
            await webViewController!.evaluateJavascript(
                source:
                    'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply > tbody > tr:nth-child($i) > td:nth-child(1)").innerText'),
            ((await webViewController!.evaluateJavascript(
                        source:
                            'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply > tbody > tr:nth-child($i) > td:nth-child(2)").innerText'))
                    as String)
                .trim()
          ]);

          setState(() {
            dataLoaded = true;
          });
        }
        break;
      } else if (i == 30) {
        print('網路異常，連線超時！');
        Navigator.pop(context);
        showToast('網路異常 連線逾時');
        break;
      }
    }
  }

  void selectUserType() async {
    for (int i = 1; i <= 30; i++) {
      await webViewController!.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply_btnApply").click()');
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('計時器 $i');

      String? userTypeClickState = await webViewController!.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_rblApplySel > tbody > tr > td:nth-child(1)").innerText');

      if (userTypeClickState == '本校在校生') {
        print('載入完成');
        await webViewController!.evaluateJavascript(
            source:
                'document.querySelector("#ctl00_MainContentPlaceholder_rblApplySel_0").click()');
        await webViewController!.evaluateJavascript(
            source:
                'document.querySelector("#ctl00_MainContentPlaceholder_btnSel").click()');
        //點完身分別後送出

        break;
      } else if (i == 5 && userTypeClickState == "") {
        print('網路異常，連線超時！');
        Navigator.pop(context);
        showToast('登入逾時');
        break;
      }
    }
  }

  void _signUp(String? _id, String? _pwd) async {
    for (int i = 0; i <= 5; i++) {
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('身分計時器 $i');

      String? userTypeLoadState = await webViewController!.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_lblTitle").innerText');

      if (userTypeLoadState == '本校在校生登入') {
        print('身分載入完成');
        await webViewController!.evaluateJavascript(
            source:
                'document.querySelector("#ctl00_MainContentPlaceholder_UserName").value="$_id"');
        await webViewController!.evaluateJavascript(
            source:
                'document.querySelector("#ctl00_MainContentPlaceholder_Password").value="$_pwd"');
        await webViewController!.evaluateJavascript(
            source:
                'document.querySelector("#ctl00_MainContentPlaceholder_LoginButton").click()');

        break;
      } else if (i == 5 && userTypeLoadState == "") {
        print('網路異常，連線超時！');
        Navigator.pop(context);
        showToast('登入逾時');
        break;
      }
    }
  }

//登入完檢查是否跳轉至填寫資料處
  void checkPage() async {
    for (int i = 1; i <= 30; i++) {
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('登入計時器 $i');

      String? loginLoadState = await webViewController!.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_lblActTitle_T").innerText');
      print(loginLoadState);

      if (loginLoadState == '活動名稱') {
        cleanJS.forEach((element) async {
          await webViewController!.evaluateJavascript(source: element);
        });
        webViewController!.zoomBy(zoomFactor: 3.0);
        print('載入完成');
        setState(() {
          dataLoaded = true;
          opacity = 1;
        });
        break;
      } else if (i == 30) {
        print('網路異常，連線超時！');
        Navigator.pop(context);
        showToast('登入逾時');
        break;
      }
    }
  }

  void _login() async {
    dataLoaded = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _id = prefs.getString('id');
    String? _pwd = prefs.getString('pwd');

    selectUserType();
    _signUp(_id, _pwd);
    checkPage();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            dataLoaded
                ? Row(children: [
                    SizedBox(
                      width: 10.0,
                    ),
                    TextButton(
                      onPressed: () {
                        if (signUpClicked) {
                          webViewController!.evaluateJavascript(
                              source:
                                  'document.querySelector("#ctl00_MainContentPlaceholder_btnStd").click()');
                        } else {
                          setState(() {
                            signUpClicked = true;
                          });
                          _login();
                        }
                      },
                      child: Text(
                        signUpClicked ? '送出' : '報名',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ])
                : SizedBox(),
            Expanded(child: SizedBox()),
            IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                )),
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
                              'https://syscc.niu.edu.tw/Activity/ApplyList.aspx')));
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
                  if (url.toString() ==
                          'https://syscc.niu.edu.tw/Activity/ApplyList.aspx' &&
                      !dataLoaded)
                    getEventInfo(widget.eventJS);
                  else if (url.toString().contains(
                      'https://syscc.niu.edu.tw/Activity/SignManagement/AddStdSignData.aspx'))
                    print('填寫資料');
                  await controller.evaluateJavascript(source: '''
                  document.lastElementChild.appendChild(document.createElement('style')).textContent = `html {filter: sepia(40%) grayscale(50%) brightness(80%) !important}`;
                  ''');
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
                  showToast(jsAlertRequest.message!
                      .replaceAll('報名資料維護可至「檢閱及修改個人報名資料」修改或取消報名!', '')
                      .replaceAll('填寫資料', '')
                      .replaceAll('\n', ''));
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
                visible: dataLoaded && !signUpClicked,
                child: data.isNotEmpty
                    ? Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListView.separated(
                            itemCount: data.length,
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(),
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                                  children: [
                                    ListTile(
                                      leading: Text(
                                        data[index][0],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      title: Text(
                                        data[index][1],
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 14.0),
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
