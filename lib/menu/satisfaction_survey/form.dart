import 'dart:developer';

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

void toDoFormAlert(BuildContext context) {
  Alert(
    context: context,
    style: AlertStyle(
        isCloseButton: false,
        alertAlignment: Alignment.center,
        buttonAreaPadding: EdgeInsets.all(10)),
    image: SizedBox(
      height: 150,
      width: 150,
      child: Image.asset('assets/satisfaction_black.png'),
    ),
    content: Column(
      children: [
        Text(
          '是否願意幫我們填寫意願表單呢？',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w200),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          ' 填寫完成將解鎖黑色主題哦！',
          style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
        ),
      ],
    ),
    buttons: [
      DialogButton(
        child: Text(
          "現在不要",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.pinkAccent,
      ),
      DialogButton(
        child: Text(
          "前往填寫",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SatisfactionSurvey(),
                  maintainState: false));
        },
        color: Colors.blueAccent,
      ),
    ],
  ).show();
}

class SatisfactionSurvey extends StatefulWidget {
  const SatisfactionSurvey({
    Key? key,
  }) : super(key: key);

  @override
  _SatisfactionSurveyState createState() => new _SatisfactionSurveyState();
}

class _SatisfactionSurveyState extends State<SatisfactionSurvey> {
  final GlobalKey satisfactionSurvey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
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
  List googleFormUrl = [
    'https://docs.google.com/forms/d/e/1FAIpQLScHj4S0Yd8gzC90PWRVfPiA8gIA1Dy1XcK7VlwNA98siDUYbg/viewform?usp=sf_link',
    'https://docs.google.com/forms/d/e/1FAIpQLSe5l6o9TdooOHXFvutrRxtl1VihaFaKuXp7L6xnyGliVzcN0g/viewform?usp=sf_link'
  ];
  String js = '''
    javascript:(
      function() {
	      //帳號資訊
        document.querySelector("#mG61Hd > div.freebirdFormviewerViewFormCard.exportFormCard > div > div.freebirdFormviewerViewNoPadding > div > div.freebirdFormviewerViewHeaderHeaderFooter > div.freebirdFormviewerViewHeaderEmailAndSaveStatusContainer").style.display = 'none';
	      //GoogleInfo
	      document.querySelector("body > div > div:nth-child(2) > div").style.display = 'none';
	      document.querySelector("body > div.freebirdFormviewerViewFormContentWrapper > div.freebirdFormviewerViewFeedbackSubmitFeedbackButton > div").style.display = 'none';
	      document.querySelector("#mG61Hd > div.freebirdFormviewerViewFormCard.exportFormCard > div > div.freebirdFormviewerViewNoPadding > div > div.freebirdFormviewerViewHeaderHeaderBody").style.display = 'none';
	      document.querySelector("#mG61Hd > div.freebirdFormviewerViewFormCard.exportFormCard > div > div.freebirdFormviewerViewNoPadding > div > div.freebirdFormviewerViewHeaderHeaderSeparator").style.display = 'none';
	      document.querySelector("#mG61Hd > div.freebirdFormviewerViewFormCard.exportFormCard > div > div.freebirdFormviewerViewNavigationNavControls > div.freebirdFormviewerViewNavigationPasswordWarning").style.display = 'none';
	      //FixBug
	      if(document.querySelector("#mG61Hd > div.freebirdFormviewerViewFormCard.exportFormCard > div > div.freebirdFormviewerViewNavigationNavControls > div.freebirdFormviewerViewNavigationButtonsAndProgress.hasClearButton > div.freebirdFormviewerViewNavigationLeftButtons > div.appsMaterialWizButtonEl.appsMaterialWizButtonPaperbuttonEl.appsMaterialWizButtonPaperbuttonFilled.freebirdFormviewerViewNavigationSubmitButton.freebirdThemedFilledButtonM2 > span > span") != null){
	        document.querySelector("#mG61Hd > div.freebirdFormviewerViewFormCard.exportFormCard > div > div.freebirdFormviewerViewNavigationNavControls > div.freebirdFormviewerViewNavigationButtonsAndProgress.hasClearButton > div.freebirdFormviewerViewNavigationLeftButtons > div.appsMaterialWizButtonEl.appsMaterialWizButtonPaperbuttonEl.appsMaterialWizButtonPaperbuttonProtected.freebirdFormviewerViewNavigationNoSubmitButton.freebirdThemedProtectedButtonM2 > span").style.width= '29px';
	        document.querySelector("#mG61Hd > div.freebirdFormviewerViewFormCard.exportFormCard > div > div.freebirdFormviewerViewNavigationNavControls > div.freebirdFormviewerViewNavigationButtonsAndProgress.hasClearButton > div.freebirdFormviewerViewNavigationLeftButtons > div.appsMaterialWizButtonEl.appsMaterialWizButtonPaperbuttonEl.appsMaterialWizButtonPaperbuttonFilled.freebirdFormviewerViewNavigationSubmitButton.freebirdThemedFilledButtonM2 > span > span").style.width= '29px';
	      }
	      }
	    )()
''';
  int submitCount = 0;
  bool loadState = false;

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
    final themeChange = Provider.of<DarkThemeProvider>(context);
    String getGoogleUrl() {
      if (themeChange.darkTheme) {
        return googleFormUrl[1];
      } else {
        return googleFormUrl[0];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('滿意度調查'),
      ),
      body: SafeArea(
          child: Column(children: <Widget>[
        Expanded(
          child: Stack(
            children: [
              Visibility(
                visible: !loadState,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                  child: HtmlWidget(
                                      '''<p style="text-align: left;">您好:</p>
<p style="text-align: justify;">　這是一份宜大學生APP滿意度願調查問卷，請您仔細閱讀，並在適當的答案欄中勾選，本問卷僅供APP內部開發使用，您所填答的資料絕對不會對外公開，請您放心作答，您的寶貴意見將有助於我們早日完成上架，感謝您的參與。</p>
<p style="text-align: left;">　國立宜蘭大學資訊工程學系二年級學生</p>
<p style="text-align: right;line-height:5px">章沛倫、呂紹誠、賴宥蓁、周楷崴</p>
<p style="text-align: left;">　指導教授</p>
<p style="text-align: right;line-height:5px">黃朝曦 副教授</p>''')),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            loadState = true;
                          });
                        },
                        child: Text(
                          '了解',
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: loadState,
                maintainState: true,
                child: InAppWebView(
                  key: satisfactionSurvey,
                  initialUrlRequest: URLRequest(url: Uri.parse(getGoogleUrl())),
                  initialOptions: options,
                  onWebViewCreated: (controller) async {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) async {
                    setState(() {
                      this.url = url.toString();
                    });
                  },
                  onLoadStop: (controller, url) async {
                    print("onLoadStop $url");
                    setState(() {
                      this.url = url.toString();
                    });
                    await controller.evaluateJavascript(source: js);
                    if (url.toString().contains('formResponse') &&
                        await controller.evaluateJavascript(
                                source:
                                    'document.querySelector("body > div.freebirdFormviewerViewFormContentWrapper > div:nth-child(2) > div.freebirdFormviewerViewFormCard.exportFormCard > div > div.freebirdFormviewerViewResponseConfirmationMessage")') !=
                            null &&
                        submitCount != 2) {
                      submitCount++;
                      print('--- submitCount ---' + submitCount.toString());
                    } else if (submitCount == 2) {
                      print('--- 成功送出 ---');
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('isDoneForm', true);
                      context.read<DarkThemeProvider>().asyncDoneForm();
                      Navigator.pop(context);
                      Future.delayed(Duration(milliseconds: 500), () async {
                        showToast('成功送出 (並成功解鎖黑色主題，可在設定中開啟)');
                      });
                    }
                  },
                  onLoadError: (controller, url, code, message) {},
                  onUpdateVisitedHistory:
                      (controller, url, androidIsReload) async {
                    setState(() {
                      this.url = url.toString();
                    });
                    print('onUpdateVisitedHistory:' + url.toString());
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
              )
            ],
          ),
        ),
      ])),
    );
  }
}
