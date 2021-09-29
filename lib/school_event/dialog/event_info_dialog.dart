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
  HeadlessInAppWebView? headlessWebView;
  bool dataLoaded = false;
  bool signUpClicked = false;
  bool loginLoaded = false;
  String url = '';
  List data = [];

  void getEventInfo(String js) async {
    data.clear();
    for (int i = 1; i <= 30; i++) {
      await headlessWebView?.webViewController
          .evaluateJavascript(source: widget.eventJS);
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('計時器 $i');

      String? loadState = await headlessWebView?.webViewController
          .evaluateJavascript(
              source:
                  'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply > caption").innerText');

      if (loadState == '活動詳細內容') {
        print('載入完成');

        for (int i = 2;
            await headlessWebView?.webViewController.evaluateJavascript(
                    source:
                        'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply > tbody > tr:nth-child($i) > td:nth-child(1)")') !=
                null;
            i++) {
          print(i);
          data.add([
            await headlessWebView?.webViewController.evaluateJavascript(
                source:
                    'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply > tbody > tr:nth-child($i) > td:nth-child(1)").innerText'),
            await headlessWebView?.webViewController.evaluateJavascript(
                source:
                    'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply > tbody > tr:nth-child($i) > td:nth-child(2)").innerText')
          ]);

          setState(() {
            dataLoaded = true;
          });
        }
        break;
      } else if (i == 30 && loadState == null) {
        print('網路異常，連線超時！');
        Navigator.pop(context);
        showToast('網路異常 連線逾時');
        break;
      }
    }
  }

  void timer() async{
    for(int i=1; i<=30; i++){
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('計時器 $i');

      String? userTypeLoadState = await headlessWebView?.webViewController
          .evaluateJavascript(
          source:
          '');

      if (userTypeLoadState == '') {
        print('載入完成');
        await headlessWebView?.webViewController.evaluateJavascript(
            source:
            '');
        break;
      } else if (i == 30 && userTypeLoadState == null) {
        print('網路異常，連線超時！');
        Navigator.pop(context);
        showToast('登入逾時');
        break;
      }
    }
  }

  void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? pwd = prefs.getString('pwd');
    for (int i = 1; i <= 30; i++) {
      await headlessWebView?.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#ctl00_MainContentPlaceholder_dvGetDetailApply_btnApply").click()');
      await Future.delayed(Duration(milliseconds: 1000), () {});
      print('計時器 $i');

      String? userTypeClickState = await headlessWebView?.webViewController
          .evaluateJavascript(
              source:
                  'document.querySelector("#ctl00_MainContentPlaceholder_rblApplySel > tbody > tr > td:nth-child(1)").innerText');

      if (userTypeClickState == '本校在校生') {
        print('載入完成');
        await headlessWebView?.webViewController.evaluateJavascript(
            source:
                'document.querySelector("#ctl00_MainContentPlaceholder_rblApplySel_0").click()');
        await headlessWebView?.webViewController.evaluateJavascript(
            source:
            'document.querySelector("#ctl00_MainContentPlaceholder_btnSel").click()');
        //點完身分別後送出
        for(int i=0; i<=5; i++)
        {
          await Future.delayed(Duration(milliseconds: 1000), () {});
          print('身分計時器 $i');

          String? userTypeLoadState = await headlessWebView?.webViewController
              .evaluateJavascript(
              source:
              'document.querySelector("#ctl00_MainContentPlaceholder_lblTitle").innerText');

          if (userTypeLoadState == '本校在校生登入') {
            print('身分載入完成');
            await headlessWebView?.webViewController.evaluateJavascript(
                source:
                'document.querySelector("#ctl00_MainContentPlaceholder_UserName").value="$id"');
            await headlessWebView?.webViewController.evaluateJavascript(
                source:
                'document.querySelector("#ctl00_MainContentPlaceholder_Password").value="$pwd"');
            await headlessWebView?.webViewController.evaluateJavascript(
                source:
                'document.querySelector("#ctl00_MainContentPlaceholder_LoginButton").click()');
            //登入完檢查是否跳轉至填寫資料處
            for(int i=1; i<=30; i++){
              await Future.delayed(Duration(milliseconds: 1000), () {});
              print('登入計時器 $i');

              String? loginLoadState = await headlessWebView?.webViewController
                  .evaluateJavascript(
                  source:
                  'document.querySelector("#ctl00_MainContentPlaceholder_lblActTitle_T").innerText');
              print(loginLoadState);

              if (loginLoadState=='活動名稱') {
                print('載入完成');
                loginLoaded = true;
                break;
              } else if (i == 30) {
                print('網路異常，連線超時！');
                Navigator.pop(context);
                showToast('登入逾時');
                break;
              }
            }

            break;
          } else if (i == 5 && userTypeLoadState == "") {
            print('網路異常，連線超時！');
            Navigator.pop(context);
            showToast('登入逾時');
            break;
          }
        }
        break;
      } else if (i == 5 && userTypeClickState == "") {
        print('網路異常，連線超時！');
        Navigator.pop(context);
        showToast('登入逾時');
        break;
      }
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
        if (url.toString() ==
                'https://syscc.niu.edu.tw/Activity/ApplyList.aspx' &&
            !dataLoaded) getEventInfo(widget.eventJS);
        else if (url.toString().contains(
            'https://syscc.niu.edu.tw/Activity/SignManagement/AddStdSignData.aspx'))
          print('填寫資料');
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
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            dataLoaded
                ? TextButton(
                    onPressed: () {
                      _login();
                    },
                    child: Text('報名'),
                    style: ButtonStyle(),
                  )
                : SizedBox(),
            Expanded(child: SizedBox()),
            IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: Icon(Icons.close)),
          ],
        ),
        dataLoaded
            ? Expanded(
                child: ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (BuildContext context, int index) => Column(
                          children: [
                            ExpansionTile(
                              key: PageStorageKey(
                                  'event_info' + index.toString()),
                              title: Text(
                                data[index][0],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    data[index][1],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
              )
            : Expanded(
                child: NiuIconLoading(
                  size: 80.0,
                ),
              ),
      ]),
    );
  }
}
