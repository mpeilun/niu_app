import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/dark_mode_provider.dart';

class MultiplicationTableCell extends StatelessWidget {
  final String value;
  final Color color;
  final Color verBorderColor;
  final Color horBorderColor;
  final double width;
  final double height;
  final double topRadius;
  final double bottomRadius;
  final double marginTop;
  final double marginBottom;
  final double marginHor;

  MultiplicationTableCell({
    this.value = '',
    this.color = Colors.transparent,
    this.verBorderColor = Colors.black12,
    this.horBorderColor = Colors.black12,
    this.width = 40,
    this.height = 40,
    this.topRadius = 0,
    this.bottomRadius = 0,
    this.marginTop = 0,
    this.marginBottom = 0,
    this.marginHor = 0,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          border: Border.symmetric(
              vertical: BorderSide(width: 0.75, color: verBorderColor),
              horizontal: BorderSide(width: 0.75, color: horBorderColor))),
      alignment: Alignment.center,
      child: Container(
        margin:
            EdgeInsets.fromLTRB(marginHor, marginTop, marginHor, marginBottom),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(topRadius),
              bottom: Radius.circular(bottomRadius)),
        ),
        child: Center(
          child: Text(
            '$value',
            style: TextStyle(fontSize: 14.0, fontWeight: themeChange.darkTheme ? FontWeight.bold : FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
