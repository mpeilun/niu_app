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
  List contents = [];
  List<String> links = [];
  var date;
  int page = 1;

  ScrollController _controller = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<bool> isFinish() async {
    await getPost(page);
    return true;
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 10000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {
      page++;
    });
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            isFinish(), // the function to get your data from firebase or firestore
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
                  //controller: _controller,
                  itemCount: contents.length,
                  itemBuilder: (context, index) {
                    var item = contents[index];
                    print(page);
                    print(contents.length);
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
                          title: Text(item.text
                              .substring(17)
                              .replaceAll("\n", "")
                              .replaceAll(" ", "")),
                          subtitle: Text(
                            item.text
                                .substring(0, 17)
                                .replaceAll(" ", "")
                                .replaceAll("\n", ""),
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.right,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnnouncementWebView(
                                          announcementUrl: links[index],
                                          announcementTitle: item.text
                                              .replaceAll("\n", "")
                                              .replaceAll(" ", "")
                                              .toString()
                                              .split(']')[1],
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
              floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.arrow_upward),
                      onPressed: () {
                        _controller.animateTo(
                          .0,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      }),
            );
          }
        });
  }

  Future<void> getPost(int page) async {
    Dio dio = new Dio();
    Response res = await dio
        .get("https://www.niu.edu.tw/files/501-1000-1019-$page.php?Lang=zh-tw");
    var document = parse(res.data);
    var tempList = document.getElementsByClassName(
        "h5"); //print(tempList[i].text.replaceAll("\n","")  =>   [ 2021-07-26  ] 【公告】本校110學年度教務處行事曆
    tempList.removeRange(0, 8);
    contents.addAll(tempList);
    for (var content in contents) {
      if (content.children[1].attributes['href'][0].toString() == ("/")) {
        links.add(
            "https://academic.niu.edu.tw${content.children[1].attributes['href']}");
      } else {
        links.add(content.children[1].attributes['href']
            .toString()
            .replaceAll('http://', 'https://'));
      }
    }
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
