import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class getHTML {
  getHTML(){
    get();
  }
  bool enable = false;
  int weekDayNum = 5;
  int classNum = 14;
  // arr[classNum][weekDayNum]
  List<List<String?>> htmlCode = <List<String?>> [];

  HeadlessInAppWebView headlessWebView = new HeadlessInAppWebView(
    initialUrlRequest: URLRequest(
        url: Uri.parse(
            "https://acade.niu.edu.tw/NIU/Application/TKE/TKE22/TKE2240_01.aspx"),
        headers:{"Referer":"https://acade.niu.edu.tw/NIU/Application/TKE/TKE22/TKE2240_.aspx?progcd=TKE2240"}
    ),
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
    },
  );

  Future<void> get() async {
    headlessWebView.run();
    var result;
    var buttonResult;
    //等待網頁載入結束
    do {
      result = await headlessWebView.webViewController
          .evaluateJavascript(
          source:
          'document.querySelector("#Span2").innerText;');
      if(result == "目前學期")
        break;
      await Future.delayed( Duration(milliseconds: 100));
    }while( result != "目前學期");
    print("finish1");
    //按下按鈕
    await headlessWebView.webViewController.evaluateJavascript(
        source:
        'document.querySelector("#QUERY_BTN3").click();');
    //等待課表載入結束
    do{
      buttonResult = await headlessWebView.webViewController
          .evaluateJavascript(
          source:
          'document.querySelector("#table2 > tbody > tr:nth-child(1) > td:nth-child(2)").innerText;');
      if(buttonResult == "星期一")
        break;
      await Future.delayed( Duration(milliseconds: 100));
    }while( buttonResult != "星期一");

    //讀取課表
/*
    var thisBlock;
    thisBlock = await headlessWebView.webViewController
        .evaluateJavascript(
        source:
        'document.querySelector("#table2 > tbody > tr:nth-child(' + (0+2).toString() + ') > td:nth-child(' +  (0+2).toString()  + ')").innerHTML');
    print(thisBlock);*/

    for(int i = 0; i < classNum; i++){
      List<String?> tempHtmlCode = [];
      for(int j = 0; j < weekDayNum; j++){
        var thisBlock;
        thisBlock = await headlessWebView.webViewController
            .evaluateJavascript(
            source:
            'document.querySelector("#table2 > tbody > tr:nth-child(' + (i+2).toString() + ') > td:nth-child(' +  (j+2).toString()  + ') > a").innerHTML');
        tempHtmlCode.add(thisBlock);
      }
      htmlCode.add(tempHtmlCode);
    }
    enable = true;
    return;
  }
}