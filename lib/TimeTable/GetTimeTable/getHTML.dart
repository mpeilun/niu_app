import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class getHTML {
  getHTML(){
    get();
  }
  bool enable = false;
  int weekDayNum = 5;
  int classNum = 14;
  // arr[classNum][weekDayNum]
  List<List<String?>> teacher = <List<String?>> [];
  List<List<String?>> name = <List<String?>> [];
  List<List<String?>> address = <List<String?>> [];
  Future<void> get() async {

    HeadlessInAppWebView headlessWebView;
    headlessWebView = new HeadlessInAppWebView(
      onConsoleMessage: (controller, consoleMessage) {
        print("CONSOLE MESSAGE: " + consoleMessage.message);
      },
    );
    headlessWebView.run();

    await headlessWebView.webViewController.loadUrl(
        urlRequest: URLRequest(
            url: Uri.parse(
                "https://acade.niu.edu.tw/NIU/Application/TKE/TKE22/TKE2240_01.aspx")));
    var result = await headlessWebView.webViewController
        .evaluateJavascript(
        source:
        'document.querySelector("#table2 > tbody > tr:nth-child(2) > td:nth-child(2)").value;');
    print(result);


    for(int i = 0; i < classNum; i++){
      List<String?> teacherTemp = <String?>[];
      List<String?> nameTemp = <String?>[];
      List<String?> addressTemp = <String?>[];
      for(int j = 0; j < weekDayNum; j++){

      }
    }
    return;
  }
}