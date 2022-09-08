import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/login/login_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetHTML {
  final BuildContext context;

  GetHTML(this.context);

  Future<bool> getIsFinish() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getStringList(
    //         prefs.getString("id").toString() + "TimeTableP") ==
    //     null) {
    //   print("Get from web");
    //   await getFromWeb('111');
    // } else {
    //   print("Get from local");
    //   htmlCode = saveListToList(prefs.getStringList(
    //       prefs.getString("id").toString() + "TimeTableP"));
    //   //await Future.delayed(const Duration(milliseconds: 1000), (){});
    // }
    await getFromWeb();


    timetable.forEach((element) {
      print(element);
    });
    print("Load finish!");
    return true;
  }

  int weekDayNum = 7;
  int classNum = 14;
  List<List<String?>> timetable = <List<String?>>[];
  late HeadlessInAppWebView headlessWebView;

  Future<void> getFromWeb() async {
    var _url;
    var loadWeb;
    var loadTimetable;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    headlessWebView = new HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://acade.niu.edu.tw/NIU/Application/TKE/TKE22/TKE2240_01.aspx"),
            headers: {
              "Referer":
                  "https://acade.niu.edu.tw/NIU/Application/TKE/TKE22/TKE2240_.aspx?progcd=TKE2240"
            }),
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
        },
        onLoadStop: (controller, url) async {
          print("onLoadStop $url");
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          print("onUpdateVisitedHistory $url");
          _url = url.toString();
        });

    _shouldRunWebView();

    await Future.delayed(Duration(milliseconds: 500));
    while (_url !=
        "https://acade.niu.edu.tw/NIU/Application/TKE/TKE22/TKE2240_01.aspx")
      await Future.delayed(Duration(milliseconds: 100));
    print("載入：" + _url);

    // 等待網頁載入結束
    do {
      loadWeb = await headlessWebView.webViewController.evaluateJavascript(
          source: 'document.querySelector("#Span2").innerText;');
      if (loadWeb == "目前學期") break;
      await Future.delayed(Duration(milliseconds: 100));
    } while (loadWeb != "目前學期");

    // 按下按鈕
    await headlessWebView.webViewController.evaluateJavascript(
        source: 'document.querySelector("#QUERY_BTN3").click();');

    //等待課表載入結束
    do {
      loadTimetable = await headlessWebView.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#table2 > tbody > tr:nth-child(1) > td:nth-child(2)").innerText;');
      if (loadTimetable == "星期一") break;
      await Future.delayed(Duration(milliseconds: 100));
    } while (loadTimetable != "星期一");

    // 讀取課表
    for (int i = 0; i < classNum; i++) {
      List<String?> tempHtmlCode = [];
      for (int j = 0; j < weekDayNum; j++) {
        var thisBlock;
        thisBlock = await headlessWebView.webViewController.evaluateJavascript(
            source: 'document.querySelector("#table2 > tbody > tr:nth-child(' +
                (i + 2).toString() +
                ') > td:nth-child(' +
                (j + 2).toString() +
                ') > a").innerHTML');
        tempHtmlCode.add(thisBlock);
      }
      timetable.add(tempHtmlCode);
    }

    await prefs.setStringList(
        prefs.getString("id").toString() + "TimeTableP",
        listToSaveList(timetable));
  }

  List<String> listToSaveList(List<List<String?>> list) {
    List<String> saveList = <String>[];
    for (int i = 0; i < classNum; i++) {
      String temp = "";
      for (int j = 0; j < weekDayNum; j++) {
        if (timetable[i][j] != null)
          temp += timetable[i][j].toString();
        else
          temp += "&sp"; // space
        temp += "\\";
      }
      saveList.add(temp);
    }
    return saveList;
  }

  List<List<String?>> saveListToList(List<String>? saveList) {
    List<List<String?>> list = <List<String?>>[];
    if (saveList != null) {
      for (int i = 0; i < classNum; i++) {
        int index = 0;
        List<String?> tempList = [];
        for (int j = 0; j < weekDayNum; j++) {
          String tempString =
              saveList[i].substring(index, saveList[i].indexOf("\\", index));
          if (tempString != "&sp")
            tempList.add(tempString);
          else
            tempList.add(null);
          index = saveList[i].indexOf("\\", index) + 1;
        }
        list.add(tempList);
      }
    }
    return list;
  }

  void _shouldRunWebView() async {
    if (await Login.origin().initNiuLoin(context)) {
      headlessWebView.run();
    }
  }
}
