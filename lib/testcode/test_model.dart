// import 'dart:developer';
//
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// HeadlessInAppWebView headlessWebView = new HeadlessInAppWebView(
//   initialUrlRequest: URLRequest(
//       url: Uri.parse("url")),
//   initialOptions: InAppWebViewGroupOptions(
//     crossPlatform: InAppWebViewOptions(
//       useShouldInterceptAjaxRequest: true,
//       useOnLoadResource: true,
//     ),
//     android: AndroidInAppWebViewOptions(
//       // blockNetworkImage: true,
//     ),
//   ),
//   onWebViewCreated: (controller) async {
//     print('LoginHeadlessInAppWebView created!');
//   },
//   onConsoleMessage: (controller, consoleMessage) {
//     print('onConsoleMessage $consoleMessage.message');
//   },
//   onLoadStart: (controller, url) async {
//     print('onLoadStart: $url');
//   },
//   onLoadStop: (controller, url) async {
//     print('onLoadStop: $url');
//   },
//   onLoadError: (InAppWebViewController controller, Uri? url, int code,
//       String message) {
//     print('onLoadError: url_$url msg_$message');
//   },
//   onLoadResource:
//       (InAppWebViewController controller, LoadedResource resource) {
//     print('onLoadResource: $resource');
//   },
//   onUpdateVisitedHistory: (controller, url, androidIsReload) {
//     print('onUpdateVisitedHistory: $androidIsReload');
//   },
//   onProgressChanged: (controller, progress) {
//     print('onProgressChanged: $progress');
//   },
//   onJsAlert: (InAppWebViewController controller,
//       JsAlertRequest jsAlertRequest) async {
//     print('onJsAlert: $jsAlertRequest');
//     return JsAlertResponse(
//         handledByClient: true, action: JsAlertResponseAction.CONFIRM);
//   },
//   onAjaxProgress:
//       (InAppWebViewController controller, AjaxRequest ajaxRequest) async {
//     print('onAjaxProgress:');
//     log(ajaxRequest.toString());
//     return AjaxRequestAction.PROCEED;
//   },
//   onAjaxReadyStateChange: (controller, ajax) async {
//     print('onAjaxReadyStateChange:');
//     log(ajax.toString());
//     return AjaxRequestAction.PROCEED;
//   },
// );
//
// // await headlessWebView.run();
