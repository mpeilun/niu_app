import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/login/login_method.dart';
import 'package:niu_app/timetable/timetable_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetHTML {
  final BuildContext context;

  GetHTML(this.context);

  int weekDayNum = 7;
  int classNum = 14;
  List<List<String?>> timetable = <List<String?>>[];
  late HeadlessInAppWebView headlessWebView;

  Future<List<List<TimetableClass>>> getFromLocal() async {
    final List<List<TimetableClass>> timetableData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    timetableData = saveListToList(
        prefs.getStringList(prefs.getString("id").toString() + "TimeTable"));
    // for (int i = 0; i < 14; i++) {
    //   print(timetableData[i].map((e) => e.teacher).toList());
    // }
    return timetableData;
  }

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

    await prefs.setStringList(prefs.getString("id").toString() + "TimeTable",
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
    // print(saveList);
    return saveList;
  }

  List<List<TimetableClass>> saveListToList(List<String>? saveList) {
    final List<List<TimetableClass>> timetableData = [];
    if (saveList != null) {
      for (int i = 0; i < classNum; i++) {
        List tempClassList = saveList[i].split('\\');
        List<TimetableClass> classList = [];
        // print(tempClassList);
        for (int j = 0; j < weekDayNum; j++) {
          if (tempClassList[j] != '&sp') {
            final List classLists = tempClassList[j].split('<br>');
            // print(classList[j]);
            // print(tempClassList);
            final String teacher = classLists[0].trim();
            final String lesson = classLists[1].trim();
            final String room = classLists[2].trim();
            classList.add(TimetableClass(
              teacher: teacher,
              lesson: lesson,
              room: room,
            ));
          } else {
            classList.add(TimetableClass(
                teacher: '', lesson: '', room: '', isEmpty: true));
          }
          // print(classList[j].teacher);
        }
        timetableData.add(classList);
        // print(timetableData[i].map((e) => e.teacher).toList());
      }
    }
    return timetableData;
  }

  void _shouldRunWebView() async {
    if (await Login.origin().initNiuLoin(context)) {
      headlessWebView.run();
    }
  }
}
