import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/provider/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_eschool.dart';
import 'notificatioon_items.dart';

late HeadlessInAppWebView _notificationWebView;

Future<void> loadDataFormPrefs(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('notification_item_key')) {
    final rawData = prefs.getString('notification_item_key');
    print('---載入通知數據---');
    print(rawData);
    final List<NotificationItem> initialData =
        NotificationItem.decode(rawData!);
    context.read<NotificationProvider>().initialNotificationItem(initialData);
  }
  if (prefs.containsKey('new_notifications_count_key')) {
    final data = prefs.getInt('new_notifications_count_key');
    print('---未讀通知數量---');
    print(data);
    context.read<NotificationProvider>().initialNewNotifications(data!);
  }
}

Future<void> runNotificationWebViewWebView(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<NotificationItem> notificationItems =
      context.read<NotificationProvider>().notificationItemList;
  List<EschoolData> eschoolData = [];
  late String semester;

  _notificationWebView = new HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse("https://eschool.niu.edu.tw/mooc/login.php")),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useOnLoadResource: true,
          javaScriptCanOpenWindowsAutomatically: true,
        ),
      ),
      onWebViewCreated: (controller) {
        print('HeadlessInAppWebView created!');
      },
      onConsoleMessage: (controller, consoleMessage) {
        print("CONSOLE MESSAGE: " + consoleMessage.message);
      },
      onLoadStart: (controller, url) async {
        print("onLoadStart $url");
        if (url.toString() == 'https://eschool.niu.edu.tw/learn/index.php') {
          await _notificationWebView.webViewController.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      "https://eschool.niu.edu.tw/learn/mycourse/index.php")));
        }
      },
      onLoadStop: (controller, url) async {
        print("onLoadStop $url");
        if (url.toString() ==
                'https://eschool.niu.edu.tw/mooc/message.php?type=17' ||
            url.toString() == 'https://eschool.niu.edu.tw/mooc/index.php') {
          await _notificationWebView.webViewController.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      "https://eschool.niu.edu.tw/learn/mycourse/index.php")));
        } else if (url.toString() ==
            'https://eschool.niu.edu.tw/mooc/login.php') {
          await _login();
        }

        if (url.toString() ==
            'https://eschool.niu.edu.tw/learn/mycourse/index.php') {
          semester = (await _notificationWebView.webViewController
                      .evaluateJavascript(
                          source:
                              'document.querySelector("body > div > div > div.box2 > div:nth-child(3) > div > table > tbody > tr:nth-child(1) > td.t4 > div > a").innerText')
                  as String)
              .split('_')[0];

          for (int i = 1;
              (await _notificationWebView.webViewController.evaluateJavascript(
                              source:
                                  'document.querySelector("body > div > div > div.box2 > div:nth-child(3) > div > table > tbody > tr:nth-child($i) > td.t4 > div > a").innerText')
                          as String)
                      .split('_')[0] ==
                  semester;
              i++) {
            String courseName = (await _notificationWebView.webViewController
                        .evaluateJavascript(
                            source:
                                'document.querySelector("body > div > div > div.box2 > div:nth-child(3) > div > table > tbody > tr:nth-child($i) > td.t4 > div > a").innerText')
                    as String)
                .split('_')[1]
                .split('(')[0];
            String announcementCount =
                await _notificationWebView.webViewController.evaluateJavascript(
                        source:
                            'document.querySelector("body > div > div > div.box2 > div:nth-child(3) > div > table > tbody > tr:nth-child($i) > td:nth-child(4) > div").innerText')
                    as String;
            String workCount = await _notificationWebView.webViewController
                    .evaluateJavascript(
                        source:
                            'document.querySelector("body > div > div > div.box2 > div:nth-child(3) > div > table > tbody > tr:nth-child($i) > td:nth-child(5) > div > a").innerText')
                as String;
            eschoolData.add(EschoolData(
                courseName: courseName,
                semester: semester,
                announcementCount: announcementCount,
                workCount: workCount));
          }
          print('---Eschool Data---');
          eschoolData.forEach((element) {
            print(element.courseName +
                ' ' +
                element.semester +
                ' ' +
                element.announcementCount +
                ' ' +
                element.workCount);
          });

          if (prefs.containsKey('eschool_data_key')) {
            print('---Eschool Previous Data---');
            final rawData = prefs.getString('eschool_data_key');
            final List<EschoolData> previousData = EschoolData.decode(rawData!);
            previousData.forEach((element) {
              print(element.courseName +
                  ' ' +
                  element.semester +
                  ' ' +
                  element.announcementCount +
                  ' ' +
                  element.workCount);
            });

            int tempCount = 0;
            eschoolData.forEach((newData) {
              previousData.forEach((oldData) {
                if (newData.courseName == oldData.courseName) {
                  int announcement = int.parse(newData.announcementCount) -
                      int.parse(oldData.announcementCount);
                  int work = int.parse(newData.workCount) -
                      int.parse(oldData.workCount);
                  if (announcement > 0) {
                    tempCount++;
                    context
                        .read<NotificationProvider>()
                        .setNewNotifications(true);
                    notificationItems.insert(
                        0,
                        NotificationItem(
                            icon: 0,
                            title: newData.courseName +
                                '\n有 $announcement 筆新的公告'));
                  }
                  if (work > 0) {
                    tempCount++;
                    context
                        .read<NotificationProvider>()
                        .setNewNotifications(true);
                    notificationItems.insert(
                        0,
                        NotificationItem(
                            icon: 0,
                            title: newData.courseName + '\n有 $work 筆新的作業'));
                  }
                }
              });
            });

            context
                .read<NotificationProvider>()
                .setNewNotificationsCount(tempCount);
            context
                .read<NotificationProvider>()
                .setNotificationItemList(notificationItems);
            print('---' +
                context
                    .read<NotificationProvider>()
                    .newNotificationsCount
                    .toString() +
                '---');

            final String encodedData = EschoolData.encode(eschoolData);
            prefs.setString('eschool_data_key', encodedData);
          } else {
            final String encodedData = EschoolData.encode(eschoolData);
            await prefs.setString('eschool_data_key', encodedData);
          }
        }
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {
        print("onUpdateVisitedHistory $url");
      },
      onProgressChanged: (controller, progress) {},
      onJsAlert: (InAppWebViewController controller,
          JsAlertRequest jsAlertRequest) async {
        return JsAlertResponse(
            handledByClient: true, action: JsAlertResponseAction.CONFIRM);
      },
      onLoadResource:
          (InAppWebViewController controller, LoadedResource resource) {});

  _notificationWebView.run();
}

_login() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('id');
  String? pwd = prefs.getString('pwd');
  await _notificationWebView.webViewController.evaluateJavascript(
      source: 'document.querySelector("#username").value=\'$id\';');
  await _notificationWebView.webViewController.evaluateJavascript(
      source: 'document.querySelector("#password").value=\'$pwd\';');
  Future.delayed(Duration(milliseconds: 1000), () async {
    await _notificationWebView.webViewController.evaluateJavascript(
        source: 'document.querySelector("#btnSignIn").click();');
  });
}
