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
          Calendar input = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              int? type;
              String? name;
              String? range;
              List<bool> isSelected = <bool>[false,false,false];
              return AlertDialog(
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        height: 284 ,
                        child: Center(
                          child: Column(
                            children: [
                              ToggleButtons(
                                children: <Widget>[
                                  Text("作業"),
                                  Text("考試"),
                                  Text("報告"),
                                ],
                                onPressed: (int index) {
                                  type = index;
                                  setState(() {
                                    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                                      if (buttonIndex == index) {
                                        isSelected[buttonIndex] = true;
                                      } else {
                                        isSelected[buttonIndex] = false;
                                      }
                                    }
                                  });
                                },
                                isSelected: isSelected,
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '名稱',
                                    hintText: '清輸入名稱',
                                  ),
                                  onChanged: (text) {
                                    name = text;
                                  },
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(15),
                                  child: TextField(
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '範圍',
                                      hintText: "清輸入範圍",
                                    ),
                                    onChanged: (text) {
                                      range = text;
                                    },
                                  )
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.pop(context, Calendar(null,null,null));
                                    },
                                    child: Icon(Icons.delete),
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.pop(context, Calendar(type,name,range));
                                    },
                                    child: Icon(Icons.check),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  )
              );
            },
          );
          if(input.typeEnable || input.nameEnable || input.rangeEnable)
            WeekCalendar().push(thisClass,input);
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
//https://stackoverflow.com/questions/62034107/flutter-switch-widget-does-not-work-properly-in-the-showdialog

