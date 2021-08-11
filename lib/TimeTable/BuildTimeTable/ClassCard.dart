import 'package:flutter/material.dart';
import '../Calendar/Calendar.dart';

import 'Class.dart';
class ClassCard extends StatefulWidget {
  ClassCard.build({
    required this.thisClass,
  });
  final Class thisClass;

  @override
  _ClassCard createState() => new _ClassCard();
}
class _ClassCard extends State<ClassCard> {

  void calenderChange() async{
    await Future.delayed(Duration(seconds: 10));
    //todo:等待行事曆編輯的結束
  }

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
        onTap: () async {

          //final String? inputData = await inputDialog(context);
          //print("你輸入：$inputData");

          final int? inputData = await optionDialog(context);
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => Calendar(
                index: inputData!,
              )),
              );
            calenderChange(); //不會延遲所以應該要用setState()
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

//http://tw-hkt.blogspot.com/2019/08/flutter_87.html
enum OptionDatas { Test, Homework, paper }

Future<int?> optionDialog(BuildContext context) async {
  return await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('行事曆'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 0);
              },
              child: const Text('作業'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: const Text('考試'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 2);
              },
              child: const Text('報告'),
            ),
          ],
        );
      });
}

