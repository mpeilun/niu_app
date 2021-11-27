import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io' as dartCookies;
import 'package:html/parser.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/pdfviwer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:niu_app/provider/drawer_provider.dart';
import 'package:provider/provider.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  String url = '';
  List data = [];
  int page = 0;

  ScrollController _controller = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<bool> isFinish() async {
    return await getPost(++page);
  }

  void _onLoading() async {
    if (await getPost(++page)) {
      setState(() {
        _refreshController.loadComplete();
      });
    }
  }

  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = isFinish();
    // _controller.addListener(() {
    //   if (_controller.offset < 1000 && context.read<DrawerProvider>().showToTopBtn) {
    //     context.read<DrawerProvider>().showBtn(false);
    //   } else if (_controller.offset >= 1000 && context.read<DrawerProvider>().showToTopBtn == false) {
    //     context.read<DrawerProvider>().showBtn(true);
    //   }
    // });
  }

  @override
  void dispose() {
    data.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            _future, // the function to get your data from firebase or firestore
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.data == null) {
            return NiuIconLoading(size: 80);
            //return loading widget
          } else {
            return Scaffold(
              body: SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
                onLoading: _onLoading,
                controller: _refreshController,
                child: ListView.builder(
                  controller: _controller,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    // print(page);
                    // print(contents.length);
                    // print(index);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 0.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          //leading: Icon(Icons.event_seat),
                          title: Text(data[index]['title']),
                          subtitle: Text(
                            data[index]['date'],
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.right,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnnouncementWebView(
                                          announcementUrl: data[index]['link'],
                                          announcementTitle: data[index]['title'],
                                        ),
                                    maintainState: false));
                          },
                          //subtitle: Text('${content[index].price}'),
                        ),
                      ),
                    );
                  },
                ),
              ),
              floatingActionButton: Container(
                width: 40.0,
                height: 40.0,
                child: FloatingActionButton(
                    child: Icon(Icons.arrow_upward),
                    onPressed: () {
                      if (_controller.offset < 3000) {
                        _controller.animateTo(
                          .0,
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.ease,
                        );
                      } else {
                        _controller.jumpTo(
                          3000,
                        );
                        _controller.animateTo(
                          .0,
                          duration: Duration(milliseconds: 1500),
                          curve: Curves.ease,
                        );
                      }
                    }),
              ),
            );
          }
        });
  }

  Future<bool> getPost(int page) async {
    final Completer<bool> callBack = new Completer<bool>();
    HeadlessInAppWebView headlessWebView = new HeadlessInAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useOnLoadResource: true,
          javaScriptCanOpenWindowsAutomatically: true,
        ),
      ),
      onWebViewCreated: (controller) {
        print('HeadlessInAppWebView created!');
        controller.loadUrl(urlRequest: URLRequest(
            url: Uri.parse(
                'https://www.niu.edu.tw/files/501-1000-1019-$page.php?Lang=zh-tw')),);
      },
      onConsoleMessage: (controller, consoleMessage) {
        print("CONSOLE MESSAGE: " + consoleMessage.message);
      },
      onLoadStart: (controller, url) async {
        print("onLoadStart $url");
        setState(() {
          this.url = url.toString();
        });
      },
      onLoadResource:
          (InAppWebViewController controller, LoadedResource resource) {
        print(resource.toString());
      },
      onLoadStop: (controller, url) async {
        print("onLoadStop $url");
        print(await controller
            .evaluateJavascript(
            source:
            'document.querySelector("#Dyn_2_3 > div > div.md_middle > div > div > div > table > tbody > tr:nth-child(2) > td.mc > div > span.date")'));
        for (int i = 2;
        await controller
            .evaluateJavascript(
            source:
            'document.querySelector("#Dyn_2_3 > div > div.md_middle > div > div > div > table > tbody > tr:nth-child($i) > td.mc > div > span.date")')!=null;
        i += 3) {
          print(i);
          String js = '''
      javascript:(
function() {
    let title = document.querySelector("#Dyn_2_3 > div > div.md_middle > div > div > div > table > tbody > tr:nth-child($i) > td.mc > div > a").innerText;
    	  date = document.querySelector("#Dyn_2_3 > div > div.md_middle > div > div > div > table > tbody > tr:nth-child($i) > td.mc > div > span.date").innerText;
    	  link = document.querySelector("#Dyn_2_3 > div > div.md_middle > div > div > div > table > tbody > tr:nth-child($i) > td.mc > div > a").href;
    return {title, date,link};
}
)()
      ''';
          var result = await controller
              .evaluateJavascript(source: js);
          String date = result['date'];
          String title = result['title'];
          String link = result['link'].replaceAll('http://', 'https://');
          print(link);
          data.add({'date': date, 'title': title, 'link':link});
          // print(i.toString() + date+ text);

        }
        callBack.complete(true);
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {
        print("onUpdateVisitedHistory $url");
        setState(() {
          this.url = url.toString();
        });
      },
    );
    headlessWebView.run();
    return callBack.future;
  }
}

class AnnouncementWebView extends StatefulWidget {
  final String announcementUrl;
  final String announcementTitle;

  const AnnouncementWebView({
    Key? key,
    required this.announcementUrl,
    required this.announcementTitle,
  }) : super(key: key);

  @override
  _AnnouncementWebViewState createState() => new _AnnouncementWebViewState();
}

class _AnnouncementWebViewState extends State<AnnouncementWebView> {
  final GlobalKey announcementWebView = GlobalKey();
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
  bool js = false;
  double progress = 0;

  List<String> cleanJs = [
    'document.querySelector(\"body > div > div > div > div > div.mainhead\").style.display=\'none\'',
    'document.querySelector(\"body > div > div > div > div > div.mainbody > div > div > div > div > table > tbody > tr > td.col_01\").style.display=\'none\'',
    'document.querySelector(\"body > div > div > div > div > div.mainbody > div > div > div > div > table > tbody > tr > td.col_03\").style.display=\'none\'',
    'document.querySelector(\"#Dyn_2_1 > div\").style.display=\'none\'',
    'document.querySelector(\"body > div > div > div > div > div.mainfoot\").style.display=\'none\'',
    'document.querySelector(\"#main > div.page-title.page-title-srch\").style.display=\'none\'',
  ];

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
    return !widget.announcementUrl.contains('.pdf')
        ? Container(
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.announcementTitle),
              ),
              body: SafeArea(
                  child: Column(children: <Widget>[
                Expanded(
                  child: Stack(
                    children: [
                      InAppWebView(
                        key: announcementWebView,
                        initialOptions: options,
                        initialUrlRequest:
                            URLRequest(url: Uri.parse(widget.announcementUrl)),
                        onWebViewCreated: (controller) async {
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

                          if (uri
                              .toString()
                              .contains('niu.edu.tw/bin/downloadfile.php')) {
                            Response response = await Dio().get(uri.toString());
                            if (response.headers
                                    .toString()
                                    .contains('filename=') &&
                                response.headers
                                        .value('content-disposition')!
                                        .split('filename=')[1]
                                        .split('.')
                                        .last ==
                                    'pdf') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfViewer(
                                            title: widget.announcementTitle,
                                            url: uri.toString(),
                                            fileName: '',
                                          ),
                                      maintainState: false));
                              return NavigationActionPolicy.CANCEL;
                            } else {
                              return NavigationActionPolicy.ALLOW;
                            }
                          } else if (js) {
                            await launch(
                              uri.toString().replaceAll('http://', 'https://'),
                            );
                            return NavigationActionPolicy.CANCEL;
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          print("onLoadStop $url");
                          setState(() {
                            this.url = url.toString();
                          });
                          if (url.toString().contains('niu.edu.tw') && !js) {
                            cleanJs.forEach((element) {
                              controller.evaluateJavascript(source: element);
                            });
                            await Future.delayed(Duration(milliseconds: 200),
                                () {
                              setState(() {
                                loadState = true;
                              });
                              js = true;
                            });
                          } else {
                            setState(() {
                              loadState = true;
                            });
                          }
                        },
                        onLoadResource: (InAppWebViewController controller,
                            LoadedResource resource) {
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
                          print('onUpdateVisitedHistory:' + url.toString());
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
                        },
                        onDownloadStart: (controller, url) async {
                          download(url, context, null);
                        },
                      ),
                      Visibility(
                          visible: !loadState,
                          child: Container(
                            child: Column(
                              children: [
                                Expanded(child: NiuIconLoading(size: 80)),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ])),
            ),
          )
        : PdfViewer(
            title: widget.announcementTitle, url: widget.announcementUrl);
  }
}
