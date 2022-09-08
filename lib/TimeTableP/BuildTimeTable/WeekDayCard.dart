import 'package:flutter/material.dart';
class WeekDayCard extends StatelessWidget {
  WeekDayCard.build({
    required this.thisDay,
  });
  int thisDay;
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Center(
        child: Text(
          weekDayName[thisDay],
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

List<String> weekDayName = <String> [
  "星期一",
  "星期二",
  "星期三",
  "星期四",
  "星期五",
  "星期六",
  "星期日"
];

