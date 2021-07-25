import 'dart:async';
import 'dart:io' as dartCookies;
import 'package:app_settings/app_settings.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as dioCookieManager;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ESchoolCourseWebView extends StatefulWidget {
  @override
  _ESchoolCourseWebViewState createState() => new _ESchoolCourseWebViewState();
}

class _ESchoolCourseWebViewState extends State<ESchoolCourseWebView> {
  final GlobalKey eSchoolCourseWebView = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useOnDownloadStart: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();

    if (dartCookies.Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }

    Permission.storage.request();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (dartCookies.Platform.isAndroid) {
          webViewController?.reload();
        } else if (dartCookies.Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: <Widget>[
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                key: eSchoolCourseWebView,
                initialUrlRequest: URLRequest(
                    url: Uri.parse(
                        "https://eschool.niu.edu.tw/learn/index.php")),
                initialOptions: options,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
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
                    if (await canLaunch(url)) {
                      // Launch the App
                      await launch(
                        url,
                      );
                      // and cancel the request
                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController.endRefreshing();
                  setState(() {
                    this.url = url.toString();
                  });
                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController.endRefreshing();
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  setState(() {
                    this.url = url.toString();
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
                onDownloadStart: (controller, url) {
                  _download(url.toString());
                  //_download('https://upload.wikimedia.org/wikipedia/commons/c/c3/%E5%90%89%E7%A5%A5%E7%89%A9-%E6%B3%A2%E6%AF%94.jpg');
                },
              ),
              progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container(),
            ],
          ),
        ),
      ])),
    );
  }
}

void _download(String url) async {
  await Permission.storage.request();

  if (await Permission.storage.request().isGranted) {
    String externalDir;
    if (dartCookies.Platform.isAndroid) {
      externalDir = '/storage/emulated/0/Download';
    } else {
      externalDir = (await getApplicationDocumentsDirectory()).path;
    }

    externalDir +=
        '/' + Uri.decodeComponent(url.substring(url.lastIndexOf("/") + 1));

    print('---下載網址--- ' + url);
    print('---下載位置--- ' + externalDir);

    List<Cookie> cookies =
        await CookieManager.instance().getCookies(url: Uri.parse(url));
    await download(url, externalDir, cookies).then((value) => openFile(value));
  } else {
    Fluttertoast.showToast(
        msg: "請點選 => 權限  => 允許\"檔案和媒體\"權限",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.red,
        fontSize: 20.0);
    AppSettings.openAppSettings();
    print('無權限存取目錄');
  }
}

Future download(String url, String savePath, List<Cookie> cookies) async {
  var dio = Dio();
  var cookieJar = new CookieJar();
  List<dartCookies.Cookie> dioCookies = [];
  cookies.forEach((element) {
    dioCookies.add(new dartCookies.Cookie(element.name, element.value)
      ..httpOnly = false
      ..expires = DateTime.now().add(const Duration(hours: 1))
      ..path = '/'
      ..secure = true);
  });
  cookieJar.saveFromResponse(Uri.parse(url), dioCookies);
  dio.interceptors.add(dioCookieManager.CookieManager(cookieJar));
  print('---Cookies---');
  print(dioCookies);
  try {
    Response response = await dio.get(
      url,
      onReceiveProgress: showDownloadProgress,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
    print(response.headers);
    dartCookies.File file = dartCookies.File(savePath);
    var raf = file.openSync(mode: dartCookies.FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();
  } catch (e) {
    print(e);
  }
  return savePath;
}

Future openFile(savePath) async {
  print('---開啟檔案---');
  OpenFile.open(savePath);
}

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}
