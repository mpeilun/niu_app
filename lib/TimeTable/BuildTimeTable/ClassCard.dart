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
  Class thisClass = Class("", "", "", -1, -1, -1);
  Calendar calendar = Calendar(null, null, null);
  Calendar original = Calendar(null, null, null);
  Color roundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 12,
    );
    if (first) {
      week = widget.week;
      original = widget.calendar;
      thisClass = widget.thisClass;
      calendar = widget.calendar;
      first = false;
    }
    if (week != widget.week) {
      week = widget.week;
      original = widget.calendar;
      thisClass = widget.thisClass;
      calendar = widget.calendar;
    }

    String calendarName = calendar.name();
    if (calendarName == "null") calendarName = "";
    String calendarRange = calendar.range();
    if (calendarRange == "null") calendarRange = "";
    String classInfo = "";
    //classInfo = thisClass.name.toString() + "\n\n" + thisClass.teacher.toString() + "\n\n" + thisClass.classroom.toString();
    if (thisClass.endTime - thisClass.startTime >= 2) {
      classInfo = thisClass.name.toString() +
          "\n\n" +
          thisClass.teacher.toString() +
          "\n\n" +
          thisClass.classroom.toString();
    } else if (thisClass.endTime - thisClass.startTime == 1) {
      classInfo =
          thisClass.name.toString() + "\n\n" + thisClass.classroom.toString();
    } else {
      classInfo = thisClass.name.toString();
    }
    textStyle = TextStyle(
        fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white);
    if (calendar.type() == 0)
      roundColor = Colors.red;
    //thisClass.setColor(Colors.red);
    else if (calendar.type() == 1)
      roundColor = Colors.blue;
    //thisClass.setColor(Colors.blue);
    else if (calendar.type() == 2)
      roundColor = Colors.green;
    //thisClass.setColor(Colors.green);
    else
      roundColor = Colors.white;
    //thisClass.setColor(Color(0x2A));
    return Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: roundColor, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)),
      //elevation: 4,
      color: thisClass.getColor(),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          overlayColor: MaterialStateProperty.all<Color>(Colors.grey),
        ),
        onPressed: () async {
          print(thisClass.save() + " : " + calendar.save());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          int week = prefs.getInt("SelectWeek")!;
          if (week == -1) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: 71,
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
                }));
              },
            );
            return;
          }
          Calendar input = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              int? type = calendar.type();
              if (type == -1) type = 0;
              String? name = calendar.name();
              String? range = calendar.range();
              List<bool> isSelected = <bool>[false, false, false];
              isSelected[type] = true;
              return AlertDialog(content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ToggleButtons(
                          borderRadius: BorderRadius.circular(12.0),
                          children: <Widget>[
                            Container(
                                width:
                                    (MediaQuery.of(context).size.width - 46) /
                                        5,
                                child: Center(child: Text("作業"))),
                            Container(
                                width:
                                    (MediaQuery.of(context).size.width - 46) /
                                        5,
                                child: Center(child: Text("考試"))),
                            Container(
                                width:
                                    (MediaQuery.of(context).size.width - 46) /
                                        5,
                                child: Center(child: Text("報告"))),
                          ],
                          onPressed: (int index) {
                            type = index;
                            setState(() {
                              for (int buttonIndex = 0;
                                  buttonIndex < isSelected.length;
                                  buttonIndex++) {
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
                          padding: EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 8.0),
                          child: TextFormField(
                            initialValue: calendarName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              labelText: '名稱',
                              hintText: '請輸入名稱',
                            ),
                            onChanged: (text) {
                              if (text != "") {
                                name = text;
                                name!.replaceAll(",", "");
                              } else
                                name = null;
                            },
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              initialValue: calendarRange,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                labelText: '內容',
                                hintText: "請輸入內容",
                              ),
                              onChanged: (text) {
                                if (text != "") {
                                  range = text;
                                  range!.replaceAll(",", "");
                                } else
                                  range = null;
                              },
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                              ),
                              onPressed: () {
                                Navigator.pop(
                                    context, Calendar(null, null, null));
                              },
                              child: Icon(Icons.delete),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                              ),
                              onPressed: () {
                                Navigator.pop(
                                    context, Calendar(type, name, range));
                              },
                              child: Icon(Icons.check),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }));
            },
          );
          print(input.save());
          if (input.typeEnable || input.nameEnable || input.rangeEnable)
            WeekCalendar().push(thisClass, input, null);
          else
            WeekCalendar().del(thisClass, null);
          setState(() {
            calendar = input;
            select = true;
          });
        },
        child: SingleChildScrollView(
          child: Center(
            //padding
            child: Text(
              classInfo,
              textAlign: TextAlign.center,
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
