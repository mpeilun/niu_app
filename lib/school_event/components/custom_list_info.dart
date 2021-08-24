import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget widget;

  ListInfo({
    required this.icon,
    required this.title,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(
          bottom: screenSizeHeight * 0.015,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  SizedBox(
                    width: screenSizeWidth * 0.01,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   width: screenSizeWidth * 0.1,
            // ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}