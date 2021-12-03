import 'dart:async';
import 'dart:developer';
import 'dart:io' as dartCookies;
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../advanced_tiles.dart';
import '../e_school.dart';

class ESchoolLearning extends StatefulWidget {
  final courseId;
  final List<AdvancedTile> advancedTile;

  const ESchoolLearning({
    Key? key,
    required this.courseId,
    required this.advancedTile,
  }) : super(key: key);

  @override
  _ESchoolLearningState createState() => new _ESchoolLearningState();
}

class _ESchoolLearningState extends State<ESchoolLearning> {
  final GlobalKey eSchoolLearning = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        userAgent:
            'Mozilla/5.0 (compatible; Google AppsViewer; http://drive.google.com)',
        useOnDownloadStart: true,
        useOnLoadResource: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
        allowsAirPlayForMediaPlayback: true,
        allowsPictureInPictureMediaPlayback: true,
      ));

  late String url;
  late List<Map> learningData = [];
  bool loadState = false;
  bool shouldDownload = false;
  bool setWebViewVisibility = false;
  double progress = 0;

  //三種結果 timeout no_data result
  //if index+1 is not directory create title
  Future<List<Map>> getData() async {
    for (int i = 0; i < 60; i++) {
      await Future.delayed(Duration(milliseconds: 1000));
      print('讀取資料: ' + i.toString());
      var rawText = await webViewController!.evaluateJavascript(source: '''
                                        document
                                        .getElementById('s_catalog').contentDocument
                                        .getElementById('pathtree').contentDocument
                                        .body.outerText;
                                    ''');
      var rawHTML = await webViewController!.evaluateJavascript(source: '''
                                        document
                                        .getElementById('s_catalog').contentDocument
                                        .getElementById('pathtree').contentDocument
                                        .body.innerHTML;
                                    ''');

      if (rawHTML != null && rawText != null) {
        //無課程
        if (rawHTML
            .toString()
            .contains('''\<h4 style="text-align: center;">尚未有任何課程</h4>''')) {
          return [
            {'no_data': ''}
          ];
        }

        List listTitle = rawText.split('''\n''');
        List listJs = [];
        List tempHTML = rawHTML.split('<li id="I_SCO_');
        List<Map> result = [];

        //尚未抓取到資料
        if (listTitle.length < 2 && listJs.length < 2) {
          continue;
        }

        print(listTitle.length);
        print(tempHTML.length);

        for (int i = 0; i < tempHTML.length; i++) {
          if (tempHTML[i].toString().contains('onclick="return ')) {
            listJs.add(tempHTML[i]
                .toString()
                .split('nclick="return ')[1]
                .toString()
                .split(';')[0]
                .replaceAll('''launchActivity(this,\'''', '').replaceAll(
                    '''','null')''',
                    '').replaceAll('expanding(this)', 'directory'));
          } else if (i != 0 &&
              (tempHTML[i - 1].toString().contains('<\/li></ul></li>') ||
                  listJs[i - 1] == 'directory_no_content')) {
            listJs.add('directory_no_content');
          } else {
            listJs.add('null');
          }
        }

        // listTitle.removeLast();
        listJs.removeAt(0);

        for (int i = 0; i < listTitle.length; i++) {
          result.add({'title': listTitle[i], 'content': listJs[i]});
        }
        return result;
      }
    }
    return [
      {'timeout': ''}
    ];
  }

  @override
  void initState() {
    super.initState();

    if (dartCookies.Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
      // SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (dartCookies.Platform.isAndroid) {
      // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
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
                    child: Center(
                        child: ListView.builder(
                      itemCount: learningData.length,
                      itemBuilder: (context, index) {
                        return learningData.first.containsKey('no_data') ||
                                learningData.first.containsKey('timeout')
                            ? Text('無資料 or 讀取失敗')
                            : ListTile(
                                leading: Icon(Icons.fifteen_mp),
                                title:
                                    Text('${learningData[index]['title']}'),
                                subtitle: learningData[index]['content']
                                        .toString()
                                        .contains('I_SCO_')
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          shouldDownload = true;
                                          await webViewController!
                                              .evaluateJavascript(
                                                  source: '''
                                          document
                                          .getElementById('s_catalog').contentDocument
                                          .getElementById('pathtree').contentDocument
								                              .querySelector("#''' +
                                                      learningData[index]
                                                          ['content'] +
                                                      ''' > span > a").onclick()
                                          ''');
                                        },
                                        child: Text('下載'))
                                    : null,
                              );
                      },
                    ))),
                Visibility(
                  visible: setWebViewVisibility,
                  maintainState: true,
                  child: InAppWebView(
                    key: eSchoolLearning,
                    initialUrlRequest: URLRequest(
                        url: Uri.parse(
                            "https://eschool.niu.edu.tw/learn/index.php")),
                    initialOptions: options,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) async {
                      print("onLoadStart $url");
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
                      print('shouldOverrideUrlLoading: ' +
                          navigationAction.request.toString());
                      var uri = navigationAction.request.url!;

                      if (uri
                          .toString()
                          .contains('https://eschool.niu.edu.tw/base/')) {
                        if (shouldDownload) {
                          download(uri, context, null);
                        }
                        return NavigationActionPolicy.ALLOW;
                      }

                      if (![
                            "http",
                            "https",
                            "file",
                            "chrome",
                            "data",
                            "javascript",
                            "about"
                          ].contains(uri.scheme) ||
                          !uri.toString().contains("eschool.niu.edu.tw")) {
                        if (await canLaunch(uri.toString())) {
                          await launch(
                            uri.toString(),
                          );
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
                      if (url
                          .toString()
                          .contains('eschool.niu.edu.tw/base')) {
                        print('getUrl ' + url.toString());
                      }
                      if (url.toString() ==
                          'https://eschool.niu.edu.tw/mooc/login.php') {
                        globalAdvancedTile = [];
                        Navigator.pop(context);
                        showToast('登入逾時，重新登入中！');
                      }
                      if (url.toString() ==
                          'https://eschool.niu.edu.tw/learn/index.php') {
                        for (int i = 1; i <= 30; i++) {
                          await Future.delayed(
                              Duration(milliseconds: 1000), () {});
                          print('讀取資料 $i');
                          var raw = await controller.evaluateJavascript(
                              source:
                                  'window.frames["s_main"].document.body.innerText');
                          print('rawData $raw');
                          if (raw != null || raw != '') {
                            await Future.delayed(
                                Duration(milliseconds: 200), () async {
                              await controller.evaluateJavascript(
                                  source: 'parent.chgCourse(' +
                                      widget.courseId +
                                      ', 1, 1,\'SYS_04_01_002\')');
                              await Future.delayed(
                                  Duration(milliseconds: 200), () async {
                                await controller.evaluateJavascript(
                                    source:
                                        'document.querySelector("#envStudent").rows = \'0,*\'');
                              });
                            });
                            learningData = await getData();
                            print(learningData);
                            setState(() {
                              loadState = true;
                            });
                            break;
                          } else if (i == 30) {
                            globalAdvancedTile = [];
                            Navigator.pop(context);
                            showToast('網路異常');
                            break;
                          }
                        }
                      }
                    },
                    onLoadResource: (InAppWebViewController controller,
                        LoadedResource resource) async {
                      print('onLoadResource: $resource');
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
                      print(url.toString());
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                    onDownloadStart: (controller, url) async {
                      if (shouldDownload) {
                        download(url, context, null);
                      }
                    },
                  ),
                )
              ],
            ),
              ),
            ]),
          ),
        ),
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        shouldAddCallbacks: true);
  }
}
