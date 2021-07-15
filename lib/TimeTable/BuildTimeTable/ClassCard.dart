import 'package:flutter/material.dart';

import 'Class.dart';
class ClassCard extends StatelessWidget {
  ClassCard.build({
    required this.thisClass,
  });
  Class thisClass;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: thisClass.getColor(),  //TODO:課專屬顏色
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text("生態與環境變遷\n徐頭疼\n教101"),  //TODO:課名 老師 教室
          ),
        ),
      ),
    );
  }
}

