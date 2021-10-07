import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<void> alertGeolocation (BuildContext context) async {
  Color colorYes = Colors.blueAccent;

  if (!await Permission.location.isGranted) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "需取得權限才能獲得完整的使用體驗",
      desc: "請允許存取\"位置\"權限，以便您使用定位功能",
      buttons: [
        DialogButton(
          child: Text(
            '請點選 允許(Allow)',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
            Navigator.pop(context);
            if (!await Permission.location.request().isGranted) {
              Alert(
                context: context,
                type: AlertType.error,
                title: "無權限存取，無法使用此功能",
                desc: "請在設定中點選 => 權限  => 允許\"位置\"權限",
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
  } else if (await Permission.location.isDenied) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "無權限存取，無法使用此功能",
      desc: "請在設定中點選 => 權限  => 允許\"位置\"權限",
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
}
