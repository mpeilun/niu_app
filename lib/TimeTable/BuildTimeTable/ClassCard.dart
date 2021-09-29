import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Calendar/Calendar.dart';

import 'Class.dart';
class ClassCard extends StatefulWidget {
  ClassCard.build({
    required this.thisClass,
    required this.calendar,
    required this.week,
  });
  final Class thisClass;
  final Calendar calendar;
  final int week;

  @override
  _ClassCard createState() => new _ClassCard();
}
class _ClassCard extends State<ClassCard> {
  int week = -1;
  bool select = false;
  bool first = true;
  Class thisClass = Class("","","",-1,-1,-1);
  Calendar calendar = Calendar(null, null, null);
  Calendar original = Calendar(null, null, null);

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 12,);
    if(first){
      week = widget.week;
      original = widget.calendar;
      thisClass = widget.thisClass;
      calendar = widget.calendar;
      first = false;
    }
    if(week != widget.week){
      week = widget.week;
      original = widget.calendar;
      thisClass = widget.thisClass;
      calendar = widget.calendar;
    }

    String calendarName = calendar.name();
    if(calendarName == "null")
      calendarName = "";
    String calendarRange = calendar.range();
    if(calendarRange == "null")
      calendarRange = "";
    String classInfo = "";
    //classInfo = thisClass.name.toString() + "\n\n" + thisClass.teacher.toString() + "\n\n" + thisClass.classroom.toString();
    if(thisClass.endTime-thisClass.startTime >= 2){
      classInfo = thisClass.name.toString() + "\n\n" + thisClass.teacher.toString() + "\n\n" + thisClass.classroom.toString();
    }else if(thisClass.endTime-thisClass.startTime == 1){
      classInfo = thisClass.name.toString() + "\n\n" + thisClass.classroom.toString();
    }else {
      classInfo = thisClass.name.toString();
    }
    if(calendar.type() == 0)
      textStyle = TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white);
      //thisClass.setColor(Colors.red);
    else if(calendar.type() == 1)
      textStyle = TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white);
      //thisClass.setColor(Colors.blue);
    else if(calendar.type() == 2)
      textStyle = TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white);
      //thisClass.setColor(Colors.green);
    else
      textStyle = TextStyle(fontSize: 12,color: Colors.white);
      //thisClass.setColor(Color(0x2A));
    return Card(
      color: thisClass.getColor(),
      child: TextButton(
        style : ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          overlayColor: MaterialStateProperty.all<Color>(Colors.grey),
        ),
        onPressed: () async {
          print( thisClass.save() + " : " + calendar.save());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          int week = prefs.getInt("SelectWeek")!;
          if(week == -1){
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            height: 71 ,
                            child: Center(
                              child: Column(
                                children: [
                                  Text("寒暑假不開放行事曆"),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        RaisedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.check),
                                        ),
                                      ],
                                    ),
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
            return;
          }
          Calendar input = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              int? type = calendar.type();
              if(type == -1)
                type = 0;
              String? name = calendar.name();
              String? range = calendar.range();
              List<bool> isSelected = <bool>[false,false,false];
              isSelected[type] = true;
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
                                child: TextFormField(
                                  initialValue: calendarName,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '名稱',
                                    hintText: '清輸入名稱',
                                  ),
                                  onChanged: (text) {
                                    if(text != "") {
                                      name = text;
                                      name!.replaceAll(",", "");
                                    }
                                    else name = null;
                                  },
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(15),
                                  child: TextFormField(
                                    initialValue: calendarRange,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '內容',
                                      hintText: "清輸入內容",
                                    ),
                                    onChanged: (text) {
                                      if(text != "") {
                                        range = text;
                                        range!.replaceAll(",", "");
                                      }
                                      else range = null;
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
          print(input.save());
          if(input.typeEnable || input.nameEnable || input.rangeEnable)
            WeekCalendar().push(thisClass,input);
          else
            WeekCalendar().del(thisClass);
          setState(() {
            calendar = input;
            select = true;
          });
        },
        child: SingleChildScrollView(
          child: Center(//padding
            child: Text(
              classInfo,
              textAlign : TextAlign.center,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}

//http://tw-hkt.blogspot.com/2019/08/flutter_87.html
//https://stackoverflow.com/questions/62034107/flutter-switch-widget-does-not-work-properly-in-the-showdialog

