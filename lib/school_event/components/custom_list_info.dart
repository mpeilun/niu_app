import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:provider/provider.dart';

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
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(
          bottom: screenSizeHeight * 0.015,
        ),
        child: Row(
          children: [
            Expanded(flex: 3, child: SizedBox()),
            Expanded(
              flex: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: themeChange.darkTheme
                        ? Color(0xe0ffffff)
                        : Colors.black,
                  ),
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
            Expanded(flex: 3, child: SizedBox()),
            Expanded(
              flex: 15,
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
