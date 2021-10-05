import 'dart:isolate';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

late Isolate isolate;

void runWebView() {
  HeadlessInAppWebView headlessWebView = new HeadlessInAppWebView(
      // initialUrlRequest: URLRequest(
      //     url: Uri.parse("https://acade.niu.edu.tw/NIU/logout.aspx")),
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
      },
      onLoadStop: (controller, url) async {
        print("onLoadStop $url");
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {
        print("onUpdateVisitedHistory $url");
      },
      onProgressChanged: (controller, progress) {},
      onJsAlert: (InAppWebViewController controller,
          JsAlertRequest jsAlertRequest) async {
        return JsAlertResponse(
            handledByClient: true, action: JsAlertResponseAction.CONFIRM);
      },
      onLoadResource:
          (InAppWebViewController controller, LoadedResource resource) {});

  headlessWebView.run();
}

void startRealAsyncTask() async {
  // need a ReceivePort to receive messages.
  ReceivePort receivePort = ReceivePort();
  isolate = await Isolate.spawn(heavyTask, receivePort.sendPort);
  receivePort.listen((data) {
    print('RECEIVE: ' + data + ', ');
  });
}

void heavyTask(SendPort sendPort) {
  sendPort.send('----- run HeavyTask -----');
}

void stop() {
  isolate.kill(priority: Isolate.immediate);
}
