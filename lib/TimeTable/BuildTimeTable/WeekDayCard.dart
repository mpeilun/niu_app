import 'package:flutter/material.dart';
class WeekDayCard extends StatelessWidget {
  WeekDayCard.build({
    required this.thisDay,
  });
  int thisDay;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(11),  //2*5課表+1時間
      //child: Text("生態與環境變遷\n徐頭疼\n教101"),
      child: Text(
        weekDayName[thisDay],
        style: TextStyle(
          fontSize: 12,
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
];

