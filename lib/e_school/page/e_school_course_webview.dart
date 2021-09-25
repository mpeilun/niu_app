import 'dart:async';
import 'dart:io' as dartCookies;
import 'package:app_settings/app_settings.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as dioCookieManager;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../advanced_tiles.dart';
import '../e_school.dart';

class ESchoolCourseWebView extends StatefulWidget {
  final courseId;
  final List<AdvancedTile> advancedTile;

  const ESchoolCourseWebView({
    Key? key,
    required this.courseId,
    required this.advancedTile,
  }) : super(key: key);

  @override
  _ESchoolCourseWebViewState createState() => new _ESchoolCourseWebViewState();
}

class _ESchoolCourseWebViewState extends State<ESchoolCourseWebView> {
  final GlobalKey eSchoolCourseWebView = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useOnDownloadStart: true,
        useOnLoadResource: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late String url;
  late bool loadState = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    if (dartCookies.Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Container(
          child: Scaffold(
            body: SafeArea(
                child: Column(children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    Visibility(
                        visible: !loadState, child: NiuIconLoading(size: 80)),
                    Visibility(
                      visible: loadState,
                      maintainState: true,
                      child: InAppWebView(
                        key: eSchoolCourseWebView,
                        initialUrlRequest: URLRequest(
                            url: Uri.parse(
                                "https://eschool.niu.edu.tw/mooc/login.php")),
                        initialOptions: options,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) async {
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
                          print("onLoadStop $url");
                          setState(() {
                            this.url = url.toString();
                          });

                          if (url.toString() ==
                                  'https://eschool.niu.edu.tw/mooc/message.php?type=17' ||
                              url.toString() ==
                                  'https://eschool.niu.edu.tw/mooc/index.php') {
                            await controller.loadUrl(
                                urlRequest: URLRequest(
                                    url: Uri.parse(
                                        "https://eschool.niu.edu.tw/learn/index.php")));
                          } else if (url.toString() ==
                              'https://eschool.niu.edu.tw/mooc/login.php') {
                            await _login(controller);
                          }

                          if (url.toString() ==
                              'https://eschool.niu.edu.tw/learn/index.php') {
                            await Future.delayed(Duration(milliseconds: 200),
                                () async {
                              print('500');
                              // await controller.evaluateJavascript(
                              //     source: 'parent.chgCourse(' +
                              //         widget.courseId +
                              //         ', 1, 1)');
                              // setState(() {
                              //   loadState = true;
                              // });
                            });
                            // await Future.delayed(Duration(milliseconds: 500),
                            //     () async {
                            //   print('500');
                            //   await controller.loadUrl(
                            //       urlRequest: URLRequest(
                            //           url: Uri.parse(
                            //               "https://eschool.niu.edu.tw/forum/m_node_list.php")));
                            //   setState(() {
                            //     loadState = true;
                            //   });
                            // });
                          }
                        },
                        onLoadResource: (InAppWebViewController controller,
                            LoadedResource resource) async {
                          print(resource.toString());
                          if (resource.url.toString() ==
                              'https://eschool.niu.edu.tw/learn/mycourse/index.php') {
                            await controller.evaluateJavascript(
                                source: 'parent.chgCourse(' +
                                    widget.courseId +
                                    ', 1, 1)');
                          }
                          if (resource.url.toString() ==
                              'https://eschool.niu.edu.tw/forum/m_node_list.php') {
                            await Future.delayed(Duration(milliseconds: 500),
                                () async {
                              print('500');
                              await controller.loadUrl(
                                  urlRequest: URLRequest(
                                      url: Uri.parse(
                                          "https://eschool.niu.edu.tw/forum/m_node_list.php")));
                              setState(() {
                                loadState = true;
                              });
                            });
                          }
                        },
                        onLoadError: (controller, url, code, message) {},
                        onProgressChanged: (controller, progress) {
                          setState(() {
                            this.progress = progress / 100;
                          });
                        },
                        onUpdateVisitedHistory:
                            (controller, url, androidIsReload) {
                          setState(() {
                            this.url = url.toString();
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
                        },
                        onDownloadStart: (controller, url) async {
                          if (!await Permission.storage.isGranted) {
                            Alert(
                              context: context,
                              type: AlertType.info,
                              title: "需取得權限才能獲得完整的使用體驗",
                              desc:
                                  "數位學習園區有下載與上傳檔案之需求，請允許存取\"檔案和媒體\"權限，以便您繼續使用此功能",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    '請點選 允許(Allow)',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    if (await Permission.storage
                                        .request()
                                        .isGranted) {
                                      _download(url.toString());
                                    } else {
                                      Alert(
                                        context: context,
                                        type: AlertType.error,
                                        title: "無權限存取，無法使用此功能",
                                        desc: "請在設定中點選 => 權限  => 允許\"檔案和媒體\"權限",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "前往設定",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              AppSettings.openAppSettings();
                                            },
                                            color: Color.fromRGBO(
                                                0, 179, 134, 1.0),
                                          ),
                                        ],
                                      ).show();
                                    }
                                  },
                                  color: Color.fromRGBO(0, 179, 134, 1.0),
                                ),
                              ],
                            ).show();
                          } else if (await Permission.storage.isDenied) {
                            Alert(
                              context: context,
                              type: AlertType.error,
                              title: "無權限存取，無法使用此功能",
                              desc: "請在設定中點選 => 權限  => 允許\"檔案和媒體\"權限",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "前往設定",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    AppSettings.openAppSettings();
                                  },
                                  color: Color.fromRGBO(0, 179, 134, 1.0),
                                ),
                              ],
                            ).show();
                          } else {
                            _download(url.toString());
                          }
                          //_download('https://upload.wikimedia.org/wikipedia/commons/c/c3/%E5%90%89%E7%A5%A5%E7%89%A9-%E6%B3%A2%E6%AF%94.jpg');
                        },
                      ),
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container(),
                  ],
                ),
              ),
            ])),
          ),
        ),
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ESchool(advancedTile: widget.advancedTile),
                  maintainState: false));
          return false;
        });
  }
}

_login(InAppWebViewController webViewController) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('id');
  String? pwd = prefs.getString('pwd');
  await webViewController.evaluateJavascript(
      source: 'document.querySelector("#username").value=\'$id\';');
  await webViewController.evaluateJavascript(
      source: 'document.querySelector("#password").value=\'$pwd\';');
  Future.delayed(Duration(milliseconds: 1000), () async {
    await webViewController.evaluateJavascript(
        source: 'document.querySelector("#btnSignIn").click();');
  });
}

void _download(String url) async {
  if (await Permission.storage.isGranted) {
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
