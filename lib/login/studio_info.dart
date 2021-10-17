import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getStudioName() async {
  final Completer<String> callBack = new Completer<String>();

  HeadlessInAppWebView headlessWebView = new HeadlessInAppWebView(
    initialUrlRequest: URLRequest(
        url: Uri.parse(
            "https://acade.niu.edu.tw/NIU/Application/SESSION/SESSION_.aspx?progcd=SESSION")),
    initialOptions: InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          // useShouldInterceptAjaxRequest: true,
          ),
      android: AndroidInAppWebViewOptions(
        blockNetworkImage: true,
      ),
    ),
    onLoadStop: (controller, url) async {
      print("onLoadStop $url");
      if (url.toString() ==
          'https://acade.niu.edu.tw/NIU/Application/SESSION/SESSION_.aspx?progcd=SESSION') {
        callBack.complete((await controller.evaluateJavascript(
                source: 'document.querySelector("body").innerHTML') as String)
            .split('<br>')[8]
            .replaceAll('NAME - ', ''));
      }
    },
  );

  await headlessWebView.run();

  return callBack.future;
}

setStudioData(String id, String pwd, String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("id", id.toLowerCase());
  prefs.setString("pwd", pwd);
  prefs.setString("name", name);
}
