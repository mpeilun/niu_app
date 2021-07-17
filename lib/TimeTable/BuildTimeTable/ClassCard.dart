import 'package:flutter/material.dart';

import 'Class.dart';
class ClassCard extends StatelessWidget {
  ClassCard.build({
    required this.thisClass,
  });
  Class thisClass;
  @override
  Widget build(BuildContext context) {
    String classInfo = thisClass.name.toString() + "\n" + thisClass.teacher.toString() + "\n" + thisClass.classroom.toString();
    return Card(
      color: thisClass.getColor(),
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            //child: Text("生態與環境變遷\n徐頭疼\n教101"),
            child: Text(classInfo),
          ),
        ),
      ),
    );
  }
}

