import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void toDoFormAlert(BuildContext context) {
  final imageProvider = NetworkImage('');
  Alert(
    image: Container(
      child: Image.asset('assets/satisfaction.png'),
    ),
    context: context,
    title: "是否願意幫我們填寫意願表單呢？",
    content: SizedBox(
      child: Text(
        ' 填寫完成將解鎖黑色主題哦！',
        style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
      ),
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
