import 'dart:io' as dartCookies;
import 'package:app_settings/app_settings.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as dioCookieManager;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/toast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<void> download(Uri uri, BuildContext context) async {
  if (!await Permission.storage.isGranted) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "需取得權限才能獲得完整的使用體驗",
      desc: "請允許存取\"檔案和媒體\"權限，以便您上傳與下載檔案",
      buttons: [
        DialogButton(
          child: Text(
            '請點選 允許(Allow)',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.pop(context);
            if (await Permission.storage.request().isGranted) {
              checkDownloadInfo(uri.toString());
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
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      AppSettings.openAppSettings();
                    },
                    color: Color.fromRGBO(0, 179, 134, 1.0),
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
            style: TextStyle(color: Colors.red, fontSize: 20),
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
    checkDownloadInfo(uri.toString());
  }
}

void checkDownloadInfo(String url) async {
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
    await sendToDownload(url, externalDir, cookies)
        .then((value) => openDownloadFile(value));
  } else {
    print('無權限存取目錄');
  }
}

Future sendToDownload(String url, String savePath, List<Cookie> cookies) async {
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

Future openDownloadFile(savePath) async {
  showToast('下載完成');
  print('---開啟檔案---');
  OpenFile.open(savePath);
}

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}
