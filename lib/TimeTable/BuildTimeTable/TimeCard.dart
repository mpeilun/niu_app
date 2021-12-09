import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../provider/timetable_button_provider.dart';

class TimeCard extends StatefulWidget {
  TimeCard.build({
    required this.thisTime,
  });
  final int thisTime;

  @override
  _TimeCardState createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard> {
  List<String> time = timeName;
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          if (state) {
            context.read<TimeCardClickProvider>().setTime(timeName);
          } else {
            context.read<TimeCardClickProvider>().setTime(timeRange);
          }
          state = !state;
          print("Tap");
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            context.watch<TimeCardClickProvider>().getTime[widget.thisTime],
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

List<String> timeRange = <String>[
  "07:10\n08:00", //0
  "08:10\n09:00", //1
  "09:10\n10:00", //2
  "10:10\n11:00", //3
  "11:10\n12:00", //4
  "13:10\n14:00", //5
  "14:10\n15:00", //6
  "15:10\n16:00", //7
  "16:10\n17:00", //8
  "17:10\n18:00", //9
  "18:20\n19:10", //a
  "19:15\n20:05", //b
  "20:10\n21:00", //c
  "21:05\n21:55", //d
];

List<String> timeName = <String>[
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
