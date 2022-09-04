import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/login/login_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niu_app/service/SemesterDate.dart';

import '../BuildTimeTable/Class.dart';
import '../Calendar/Calendar.dart';

class GetHTML {
  final BuildContext context;
  GetHTML(this.context) {
    //get();
  }
  Map<Class, Calendar> calendarMap = {};
  Future<bool> getIsFinish() async {
    // SemesterDate date = SemesterDate();
    // await date.getIsFinish();
    // calendarMap =
    //     await WeekCalendar().getCalendar(await date.getSemesterWeek());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList(
            prefs.getString("id").toString() + "TimeTable" + "111") ==
        null) {
      print("Get from web");
      await getFromWeb("111");
    } else {
      print("Get from mem");
      htmlCode = saveListToList(prefs.getStringList(
          prefs.getString("id").toString() + "TimeTable" + "111"));
      //await Future.delayed(const Duration(milliseconds: 1000), (){});
    }
    print("HTML load finish!");
    return true;
  }

  int weekDayNum = 5;
  int classNum = 14;
  // arr[classNum][weekDayNum]
  List<List<String?>> htmlCode = <List<String?>>[];

  late HeadlessInAppWebView headlessWebView;

  Future<void> getFromWeb(String semester) async {
    String? _url;
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
    print(_url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result;
    var buttonResult;
    //等待網頁載入結束
    do {
      result = await headlessWebView.webViewController.evaluateJavascript(
          source: 'document.querySelector("#Span2").innerText;');
      if (result == "目前學期") break;
      await Future.delayed(Duration(milliseconds: 100));
    } while (result != "目前學期");
    //按下按鈕
    await headlessWebView.webViewController.evaluateJavascript(
        source: 'document.querySelector("#QUERY_BTN3").click();');
    //等待課表載入結束
    do {
      buttonResult = await headlessWebView.webViewController.evaluateJavascript(
          source:
              'document.querySelector("#table2 > tbody > tr:nth-child(1) > td:nth-child(2)").innerText;');
      if (buttonResult == "星期一") break;
      await Future.delayed(Duration(milliseconds: 100));
    } while (buttonResult != "星期一");
    //讀取課表
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
      htmlCode.add(tempHtmlCode);
    }
    await prefs.setStringList(
        prefs.getString("id").toString() + "TimeTable" + semester,
        listToSaveList(htmlCode));
    return;
  }

  List<String> listToSaveList(List<List<String?>> list) {
    List<String> saveList = <String>[];
    for (int i = 0; i < classNum; i++) {
      String temp = "";
      for (int j = 0; j < weekDayNum; j++) {
        if (htmlCode[i][j] != null)
          temp += htmlCode[i][j].toString();
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
