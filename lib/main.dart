import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:niu_app/TestPage/test.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var isAndroid;
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  await FlutterDownloader.initialize();
  await Permission.storage.request();

  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Test(),
      }
  ));

}

