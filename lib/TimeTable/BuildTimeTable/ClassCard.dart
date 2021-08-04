import 'package:flutter/material.dart';

import 'Class.dart';
class ClassCard extends StatefulWidget {
  ClassCard.build({
    required this.thisClass,
  });
  Class thisClass;

  @override
  _ClassCard createState() => new _ClassCard();
}
class _ClassCard extends State<ClassCard> {
  @override
  Widget build(BuildContext context) {
    Class thisClass = widget.thisClass;
    String classInfo = "";
    if(thisClass.endTime-thisClass.startTime >= 2){
      classInfo = thisClass.name.toString() + "\n\n" + thisClass.teacher.toString() + "\n\n" + thisClass.classroom.toString();
    }else if(thisClass.endTime-thisClass.startTime == 1){
      classInfo = thisClass.name.toString() + "\n\n" + thisClass.classroom.toString();
    }else {
      classInfo = thisClass.name.toString();
    }

    return Card(
      color: thisClass.getColor(),
      child: InkWell(
        onTap: () {
          setState(() {
            if(thisClass.getColor() == Colors.red)
              thisClass.setColor(Colors.green);
            else if(thisClass.getColor() == Colors.green)
              thisClass.setColor(Colors.blue);
            else if(thisClass.getColor() == Colors.blue)
              thisClass.setColor(Color(0x2));
            else
              thisClass.setColor(Colors.red);
          });
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(11),  //2*5課表+1時間
            //child: Text("生態與環境變遷\n徐頭疼\n教101"),
            child: Text(
              classInfo,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

