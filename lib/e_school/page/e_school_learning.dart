import 'dart:async';

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../e_school.dart';

bool isDownLoad = false;

class ESchoolLearning extends StatefulWidget {
  final courseName;
  final courseId;

  const ESchoolLearning({
    Key? key,
    required this.courseName,
    required this.courseId,
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
        useShouldOverrideUrlLoading: true,
        useOnLoadResource: true,
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

  late List<List<Map>> learningData = [];
  bool loadState = false;
  bool shouldDownload = false;
  bool setWebViewVisibility = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: setWebViewVisibility
              ? Opacity(
                  opacity: 0.5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: FloatingActionButton(
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        ),
                        onPressed: () async {
                          await goBack();
                        },
                      ),
                    ),
                  ),
                )
              : null,
          appBar: setWebViewVisibility
              ? null
              : AppBar(title: Text(widget.courseName)),
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
                          padding: EdgeInsets.all(8.0),
                          itemCount: learningData.length,
                          itemBuilder: (context, index) {
                            return learningData.first[0]
                                        .containsKey('no_data') ||
                                    learningData.first[0].containsKey('timeout')
                                ? Text('無資料 or 讀取失敗')
                                : Column(
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent),
                                        //learningData[index].length > 1
                                        child: AbsorbPointer(
                                          absorbing:
                                              (learningData[index].length < 2 &&
                                                  !learningData[index][0]
                                                          ['content']
                                                      .toString()
                                                      .contains('I_SCO')),
                                          child: ExpansionTile(
                                              childrenPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      .0, .0, .0, 18.0),
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              title: Text(
                                                trimTitle(learningData[index][0]
                                                    ['title']),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  // height: .1,
                                                ),
                                              ),
                                              trailing: !(learningData[index]
                                                              .length <
                                                          2 &&
                                                      !learningData[index][0]
                                                              ['content']
                                                          .toString()
                                                          .contains('I_SCO'))
                                                  ? null
                                                  : Icon(
                                                      Icons.remove,
                                                    ),
                                              children:
                                                  getList(learningData, index)
                                              //
                                              //             bool contain = tile.content
                                              // .contains('I_SCO');
                                              ),
                                        ),
                                      ),
                                      Divider(
                                        height: .0,
                                        thickness: 1.5,
                                      ),
                                    ],
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
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          var uri = navigationAction.request.url!;
                          print('------------------------------');
                          print('shouldOverrideUrlLoading: ' +
                              navigationAction.request.toString());

                          //IOS Fix 檔案下載用
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
                            if (await canLaunch(uri.toString()) &&
                                shouldDownload) {
                              isDownLoad = true;
                              setState(() {
                                setWebViewVisibility = false;
                              });
                              launch(uri.toString());
                            }
                            return NavigationActionPolicy.CANCEL;
                          }

                          if (uri.toString().contains(
                                  'https://eschool.niu.edu.tw/base/') &&
                              shouldDownload) {
                            download(uri, context, null);
                            isDownLoad = true;
                            setState(() {
                              setWebViewVisibility = false;
                            });
                            return NavigationActionPolicy.CANCEL;
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          print("onLoadStop $url");
                          if (await login(url.toString())) {
                            learningData = await getData();
                            setState(() {
                              loadState = true;
                            });
                          } else {
                            globalAdvancedTile = [];
                            Navigator.pop(context);
                          }
                        },
                        onProgressChanged: (controller, progress) {
                          setState(() {
                            this.progress = progress / 100;
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
                        },
                        onDownloadStart: (controller, url) async {
                          if (shouldDownload) {
                            download(url, context, null);
                            isDownLoad = true;
                            setWebViewVisibility = false;
                          }
                        },
                        androidOnPermissionRequest:
                            (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
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
          if (setWebViewVisibility) {
            await goBack();
          } else {
            Navigator.pop(context);
          }
          return false;
        },
        shouldAddCallbacks: true);
  }

  Future<void> goBack() async {
    isDownLoad = false;
    await webViewController?.evaluateJavascript(
        source:
            'document.getElementById(\'s_main\').contentDocument.querySelector("body").remove()');
    setState(() {
      setWebViewVisibility = false;
    });
  }

  String trimTitle(String s) {
    if (!(s.split('週')[0]).contains('第')) {
      s = '　' + s;
      return s;
    } else {
      return s;
    }
  }

  List<Widget> getList(List<List<Map>> tile, int index) {
    List<Widget> result = [];
    late int i;
    for (tile[index][0]['content'].toString().contains('I_SCO') ? i = 0 : i = 1;
        i < tile[index].length;
        i++) {
      result.add(createTitle(tile[index], i));
    }

    return result;
  }

  Widget createTitle(List<Map> tile, int index) {
    bool contain = tile[index]['content'].contains('I_SCO');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListTile(
          leading: Icon(Icons.calculate),
          title: Text(tile[index]['title']),
          subtitle: contain
              ? ElevatedButton(
                  onPressed: () async {
                    shouldDownload = true;
                    await webViewController!.evaluateJavascript(
                        source: '''
                    document
                    .getElementById('s_catalog').contentDocument
                    .getElementById('pathtree').contentDocument
                    .querySelector("#''' +
                            tile[index]['content'] +
                            ''' > span > a").onclick()
                    ''');
                    setState(() {
                      loadState = false;
                    });
                    await Future.delayed(Duration(milliseconds: 500), () async {
                      if (isDownLoad == true) {
                        isDownLoad = false;
                      } else {
                        await webViewController!.evaluateJavascript(source: '''
                        document.querySelector("#envMooc").cols = '0,*'
                        document.querySelector("#envStudent").rows = '0,*';
                        document.querySelector("#envClassRoom").cols = '0,*';
                        ''');
                        await webViewController!.evaluateJavascript(source: '''
                        document.getElementById('s_main').contentDocument.querySelector("body > iframe").style = 'position:fixed; top:0; left:0; bottom:0; right:0; width:100%; height:100%; border:none; margin:0; padding:0; overflow:hidden; z-index:999999;'
                        ''');
                        if (context.read<DarkThemeProvider>().darkTheme) {
                          await webViewController!.evaluateJavascript(
                              source:
                                  'document.getElementById(\'s_main\').contentDocument.body.style.backgroundColor = \'rgb(48,48,48)');
                        } else {
                          await webViewController!.evaluateJavascript(
                              source:
                                  'document.getElementById(\'s_main\').contentDocument.body.style.backgroundColor = \'rgb(238,238,238)');
                        }
                        setState(() {
                          setWebViewVisibility = true;
                        });
                      }
                      setState(() {
                        loadState = true;
                      });
                    });
                  },
                  child: Text('進入教材'))
              : null),
    );
  }

  Future<bool> login(String url) async {
    if (url == 'https://eschool.niu.edu.tw/mooc/login.php') {
      showToast('登入逾時，重新登入中！');
      return false;
    }
    if (url == 'https://eschool.niu.edu.tw/learn/index.php') {
      for (int i = 1; i <= 30; i++) {
        await Future.delayed(Duration(milliseconds: 1000));
        print('讀取資料 $i');
        var raw = await webViewController?.evaluateJavascript(
            source: 'window.frames["s_main"].document.body.innerText');
        print('rawData $raw');
        if (raw != null || raw != '') {
          await Future.delayed(Duration(milliseconds: 200), () async {
            await webViewController?.evaluateJavascript(
                source: 'parent.chgCourse(' +
                    widget.courseId +
                    ', 1, 1,\'SYS_04_01_002\')');
            await Future.delayed(Duration(milliseconds: 200), () async {
              await webViewController?.evaluateJavascript(
                  source:
                      'document.querySelector("#envStudent").rows = \'0,*\'');
            });
          });
          return true;
        } else if (i == 30) {
          showToast('網路異常');
          return false;
        }
      }
    }
    return true;
  }

  List<List<Map>> sortData(List input) {
    List<List<Map>> result = [];

    for (int i = 0; i < input.length; i++) {
      List<Map> temp = [];
      if (input[i]['content'] == 'directory' ||
          input[i]['content'] == 'directory_no_content') {
        temp.add(input[i]);
        if (i + 1 != input.length) {
          for (int j = i + 1;
              !(input[j]['content'] == 'directory' ||
                  input[j]['content'] == 'directory_no_content');
              j++) {
            temp.add(input[j]);
            i++;
          }
        }
      } else if (input[i]['content'].toString().contains('I_SCO')) {
        temp.add(input[i]);
      }

      result.add(temp);
    }

    return result;
  }

  Future<List<List<Map>>> getData() async {
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
          Navigator.pop(context);
          await Future.delayed(Duration(milliseconds: 200), () async {
            showToast('尚無資料');
          });
          return [
            [
              {'no_data': ''}
            ]
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

        for (int i = 0; i < listTitle.length; i++) {
          listTitle[i] = listTitle[i].toString().replaceFirst(' ', '');
        }

        if (listTitle.last.toString() == '') {
          listTitle.removeLast();
        }
        listJs.removeAt(0);

        for (int i = 0; i < listTitle.length; i++) {
          result.add({'title': listTitle[i], 'content': listJs[i]});
          print(result[i]);
        }

        return sortData(result);
      }
    }
    Navigator.pop(context);
    await Future.delayed(Duration(milliseconds: 200), () async {
      showToast('網路異常');
    });
    return [
      [
        {'timeout': ''}
      ]
    ];
  }
}
