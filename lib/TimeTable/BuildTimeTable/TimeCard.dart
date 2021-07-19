import 'package:flutter/material.dart';
class TimeCard extends StatelessWidget {
  TimeCard.build({
    required this.thisTime,
    required this.thisColor,
  });
  Color thisColor;
  int thisTime;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(11),  //2*5課表+1時間
      //child: Text("生態與環境變遷\n徐頭疼\n教101"),
      child: Text(
        timeName[thisTime],
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}

List<String> timeName = <String> [
  "特早課",
  "第一節",
  "第二節",
  "第三節",
  "第四節",
  "第五節",
  "第六節",
  "第七節",
  "第八節",
  "第九節",
  "第A節",
  "第B節",
  "第C節",
  "第D節",
];

