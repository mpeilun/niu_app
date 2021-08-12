import 'package:flutter/material.dart';
class TimeCard extends StatelessWidget {
  TimeCard.build({
    required this.thisTime,
  });
  int thisTime;
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Expanded(
        //child: Text("生態與環境變遷\n徐頭疼\n教101"),
        child: Text(
          timeName[thisTime],
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

List<String> timeName = <String> [
  "特\n早\n課",
  "第\n一\n節",
  "第\n二\n節",
  "第\n三\n節",
  "第\n四\n節",
  "第\n五\n節",
  "第\n六\n節",
  "第\n七\n節",
  "第\n八\n節",
  "第\n九\n節",
  "第\nA\n節",
  "第\nB\n節",
  "第\nC\n節",
  "第\nD\n節",
];

