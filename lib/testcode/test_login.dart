import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' as dartCookies;
import 'dart:typed_data';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/login/login_method.dart';
import 'package:niu_app/login/studio_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestLoginWebView extends StatefulWidget {
  const TestLoginWebView({
    Key? key,
  }) : super(key: key);

  @override
  _TestLoginWebViewState createState() => new _TestLoginWebViewState();
}

class _TestLoginWebViewState extends State<TestLoginWebView> {
  final GlobalKey testLoginWebViewState = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldInterceptAjaxRequest: true,
      ),
      android: AndroidInAppWebViewOptions(
        blockNetworkLoads: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late String url;
  double progress = 0;
  bool postState = false;

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
    return ConditionalWillPopScope(
        child: Container(
          child: Scaffold(
            body: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          Login.origin().niuLogin();
                        },
                        child: Text('登入')),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          print('Name: ${await getStudioName()}');
                          // CookieManager().deleteAllCookies();
                          // showToast('CleanCookies');
                        },
                        child: Text('GetNmae')),
                  )
                ])),
          ),
        ),
        onWillPop: () async {
          return true;
        },
        shouldAddCallbacks: true);
  }
}
