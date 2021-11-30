import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void toDoFormAlert(BuildContext context) {
  Alert(
    context: context,
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
          "前往填寫",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {},
        color: Colors.blueAccent,
      ),
    ],
  ).show();
}
