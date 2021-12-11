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

Future<void> download(Uri uri, BuildContext context, String? title) async {
  if (Uri.decodeComponent(
              uri.toString().substring(uri.toString().lastIndexOf("/") + 1))
          .length >
      100) {
    title = null;
  } else if (title == null) {
    title = '   ' +
        Uri.decodeComponent(
            uri.toString().substring(uri.toString().lastIndexOf("/") + 1));
  }

  Color colorYes = Colors.blueAccent;
  Color colorNo = Colors.pinkAccent;

  void askDownload() {
    Alert(
      closeIcon: Icon(Icons.close, color: Colors.grey),
      context: context,
      type: AlertType.warning,
      // title: "是否要下載此檔案至裝置？",
      // desc: title,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            "是否要下載此檔案至裝置？",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            '$title',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            "取消",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: colorNo,
        ),
        DialogButton(
          child: Text(
            "下載",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
            checkDownloadInfo(uri.toString(), title.toString());
          },
          color: colorYes,
        ),
      ],
    ).show();
  }

  if (!await Permission.storage.isGranted) {
    Alert(
      closeIcon: Icon(Icons.close, color: Colors.grey),
      context: context,
      type: AlertType.warning,
      // title: "需取得權限才能獲得完整的使用體驗",
      // desc: "請允許存取\"檔案和媒體\"權限，以便您上傳與下載檔案",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10.0,),
          Text(
            "需取得權限才能獲得完整的使用體驗",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0,),
          Text(
            "請允許存取\"檔案和媒體\"權限，以便您上傳與下載檔案",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            '請點選 允許(Allow)',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
            Navigator.pop(context);
            if (await Permission.storage.request().isGranted) {
              askDownload();
            } else {
              Alert(
                closeIcon: Icon(Icons.close, color: Colors.grey),
                context: context,
                type: AlertType.error,
                // title: "無權限存取，無法使用此功能",
                // desc: "請在設定中點選 => 權限  => 允許\"檔案和媒體\"權限",
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.0,),
                    Text(
                      "無權限存取，無法使用此功能",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0,),
                    Text(
                      "請在設定中點選 => 權限  => 允許\"檔案和媒體\"權限",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    child: Text(
                      "前往設定",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      AppSettings.openAppSettings();
                    },
                    color: colorYes,
                  ),
                ],
              ).show();
            }
          },
          color: colorYes,
        ),
      ],
    ).show();
  } else if (await Permission.storage.isDenied) {
    Alert(
      closeIcon: Icon(Icons.close, color: Colors.grey),
      context: context,
      type: AlertType.error,
      // title: "無權限存取，無法使用此功能",
      // desc: "請在設定中點選 => 權限  => 允許\"檔案和媒體\"權限",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10.0,),
          Text(
            "無權限存取，無法使用此功能",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0,),
          Text(
            "請在設定中點選 => 權限  => 允許\"檔案和媒體\"權限",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            "前往設定",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
            AppSettings.openAppSettings();
          },
          color: colorYes,
        ),
      ],
    ).show();
  } else {
    askDownload();
  }
}

void checkDownloadInfo(String url, String title) async {
  if (await Permission.storage.isGranted) {
    if (title == '') {
      showToast('開始下載檔案');
    } else {
      showToast('開始下載: ' + title);
    }

    List<Cookie> cookies =
        await CookieManager.instance().getCookies(url: Uri.parse(url));
    await sendToDownload(url, cookies).then((value) => openDownloadFile(value));
  } else {
    print('無權限存取目錄');
  }
}

Future sendToDownload(String url, List<Cookie> cookies) async {
  late String externalDir;
  late String rootDir;
  String decodeName =
      Uri.decodeComponent(url.substring(url.lastIndexOf("/") + 1));
  if (dartCookies.Platform.isAndroid) {
    rootDir = '/storage/emulated/0/Download';
  } else {
    rootDir = (await getApplicationDocumentsDirectory()).path;
  }
  externalDir = rootDir + '/' + decodeName;

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
    late dartCookies.File file;
    if (url.contains('/bin/downloadfile.php')) {
      if ((decodeName.substring(url.lastIndexOf(".") + 1).length > 20 ||
              !decodeName.contains('.')) &&
          response.headers.toString().contains('filename=')) {
        externalDir = rootDir +
            '/' +
            DateTime.now().month.toString() +
            '_' +
            DateTime.now().day.toString() +
            '_' +
            DateTime.now().hour.toString() +
            '_' +
            DateTime.now().minute.toString() +
            '_' +
            DateTime.now().second.toString() +
            '.' +
            response.headers
                .value('content-disposition')!
                .split('filename=')[1]
                .split('.')
                .last;
      }
    }
    print('---下載網址--- ' + url);
    print('---下載位置--- ' + externalDir);
    file = dartCookies.File(externalDir);
    var raf = file.openSync(mode: dartCookies.FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
  } catch (e) {
    print('Download Error' + e.toString());
  }
  return externalDir;
}

Future openDownloadFile(savePath) async {
  showToast('檔案下載完成');
  OpenFile.open(savePath);
  print('檔案下載完成!');
}

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}
