import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io' as dartCookies;
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as dioCookieManager;
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Components/Drawer.dart';
import 'FlutterDownloaderUtil.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (dartCookies.Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  await FlutterDownloader.initialize();
  await Permission.storage.request();

  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey webViewKey = GlobalKey();

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
  final urlController = TextEditingController();

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
      //監聽下載完成
      // if (status == DownloadTaskStatus.complete) {
      //   //程序休眠1s,保证下载事项处理完成
      //   sleep(Duration(seconds: 2));
      //   print('---下載成功---');
      //   FlutterDownloader.open(taskId: data[0]);
      // } else if (status == DownloadTaskStatus.failed) {
      //   print('---下載失敗---');
      // }
    });

    FlutterDownloader.registerCallback(downloadCallback);

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
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text("Website")),
          drawer: MyDrawer(),
          body: SafeArea(
              child: Column(children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
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
                        urlController.text = this.url;
                      });
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
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
                        urlController.text = this.url;
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
                        urlController.text = this.url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
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
          ]))),
    );
  }
}

void _download(String url) async {
  final status = await Permission.storage.request();

  if (status.isGranted) {
    String externalDir;
    if (dartCookies.Platform.isAndroid) {
      externalDir = '/storage/emulated/0/Download/';
    } else {
      externalDir = (await getLibraryDirectory()).path;
    }

    externalDir +=
        Uri.decodeComponent(url.substring(url.lastIndexOf("/") + 1));

    print('---下載網址--- ' + url);
    print('---下載位置--- ' + externalDir);

    List<Cookie> cookies = await CookieManager.instance().getCookies(url: Uri.parse(url));
    download(url, externalDir, cookies);
    // final id = await FlutterDownloader.enqueue(
    //   url: url,
    //   savedDir: externalDir,
    //   showNotification: true,
    //   openFileFromNotification: false,
    // );
  } else {
    print('Permission Denied');
  }
}

Future download(String url, String savePath, List<Cookie> cookies) async {
  var dio = Dio();
  var cookieJar = new CookieJar();
  List<dartCookies.Cookie> dioCookies = [];
  cookies.forEach((element) {dioCookies.add(new dartCookies.Cookie(element.name, element.value)
    ..httpOnly = false
    ..expires = DateTime.now().add(const Duration(hours: 1))
    ..path = '/'
    ..secure = true);});
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
}

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}
