import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

void showToast(String msg) {
  var toast = Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        child: Text(msg),
        onPressed: () {},
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20)),
            backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
            shape: MaterialStateProperty.all(StadiumBorder(
              side: BorderSide(color: Colors.blue[900]!),
            ))),
      ));
  showToastWidget(toast);
}

/*
const ButtonStyle({
  this.textStyle, //字型
  this.backgroundColor, //背景色
  this.foregroundColor, //前景色
  this.overlayColor, // 高亮色，按鈕處於focused, hovered, or pressed時的顏色
  this.shadowColor, // 陰影顏色
  this.elevation, // 陰影值
  this.padding, // padding
  this.minimumSize, //最小尺寸
  this.side, //邊框
  this.shape, //形狀
  this.mouseCursor, //滑鼠指標的游標進入或懸停在此按鈕的[InkWell]上時。
  this.visualDensity, // 按鈕佈局的緊湊程度
  this.tapTargetSize, // 響應觸控的區域
  this.animationDuration, //[shape]和[elevation]的動畫更改的持續時間。
  this.enableFeedback, // 檢測到的手勢是否應提供聲音和/或觸覺反饋。例如，在Android上，點選會產生咔噠聲，啟用反饋後，長按會產生短暫的振動。通常，元件預設值為true。
});
 */
