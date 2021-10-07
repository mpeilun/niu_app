import 'package:flutter/material.dart';
import 'package:niu_app/TimeTable/Calendar/Calendar.dart';
import 'package:niu_app/TimeTable/BuildTimeTable/Class.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/service/SemesterDate.dart';

class CalenderMessageType {
  CalenderMessageType(this.week, this._class, this.calendar);
  int week;
  Class _class;
  Calendar calendar;
  DateTime date(SemesterDate semester) {
    if (semester.semesterStartDay == -1) print("semester Error");
    DateTime date = DateTime.utc(semester.semesterStartYear,
        semester.semesterStartMonths, semester.semesterStartDay);
    date = date.add(Duration(days: ((week - 1) * 7 + _class.weekDay - 1)));
    return date;
  }
}

//----
class CalenderMessage {
  final List<CalenderMessageType> calenderList;

  CalenderMessage({required this.calenderList});

  set(BuildContext context, CalenderMessageType id) {
    Calendar calendar = id.calendar;
    String calendarName = calendar.name();
    if (calendarName == "null") calendarName = "";
    String calendarRange = calendar.range();
    if (calendarRange == "null") calendarRange = "";
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        int? type = calendar.type();
        if (type == -1) type = 0;
        String? name = calendar.name();
        String? range = calendar.range();
        List<bool> isSelected = <bool>[false, false, false];
        isSelected[type] = true;
        return SingleChildScrollView(
          child: AlertDialog(content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 284,
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
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: calendarName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '名稱',
                          hintText: '清輸入名稱',
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
                        RaisedButton(
                          onPressed: () {
                            WeekCalendar().del(id._class, id.week);
                          },
                          child: Icon(Icons.delete),
                        ),
                        RaisedButton(
                          onPressed: () {
                            WeekCalendar().push(id._class,
                                Calendar(type, name, range), id.week);
                          },
                          child: Icon(Icons.check),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          })),
        );
      },
    );
  }
}
//----

class ModifyCalender extends StatefulWidget {
  final CalenderMessageType calenderMessage;
  ModifyCalender({required this.calenderMessage});

  @override
  _ModifyCalenderState createState() => _ModifyCalenderState();
}

class _ModifyCalenderState extends State<ModifyCalender> {
  List<bool> isSelected = <bool>[false, false, false];
  late Calendar calendar;
  late String calendarName;
  late String calendarRange;
  late int calendarType;

  @override
  void initState() {
    super.initState();
    calendar = widget.calenderMessage.calendar;
    calendarName = calendar.name();
    calendarRange = calendar.range();
    if(calendar.type() == -1){
      calendarType = 0;
    }else{
      calendarType = calendar.type();
    }
    isSelected[calendarType] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(child: Container(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 5,),
              Text('$calendarName, $calendarRange', style: TextStyle(fontSize: 18),),
              SizedBox(height: 5,),
              ToggleButtons(
                children: <Widget>[
                  Text("作業"),
                  Text("考試"),
                  Text("報告"),
                ],
                onPressed: (int index) {
                  calendarType = index;
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
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  initialValue: calendarName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '名稱',
                    hintText: '清輸入名稱',
                  ),
                  onChanged: (text) {
                    if (text != "") {
                      calendarRange = text;
                      calendarRange.replaceAll(",", "");
                    }
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
                      if (text != "") {
                        calendarRange = text;
                        calendarRange.replaceAll(",", "");
                      }
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      WeekCalendar().del(widget.calenderMessage._class, widget.calenderMessage.week);
                      Navigator.pop(context);
                      showToast('刪除成功');
                    },
                    child: Icon(Icons.delete),
                  ),
                  SizedBox(width: 5,),
                  ElevatedButton(
                    onPressed: () {
                      WeekCalendar().push(widget.calenderMessage._class,
                          Calendar(calendarType, calendarName, calendarRange), widget.calenderMessage.week);
                      Navigator.pop(context);
                      showToast('更改成功');
                    },
                    child: Icon(Icons.check),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

Future<List<CalenderMessageType>> getCalenderList() async {
  List<CalenderMessageType> returnList = [];
  for (int i = 0; i < 18; i++) {
    Map<Class, Calendar> calenderList = await WeekCalendar().getCalendar(i);
    calenderList.forEach((key, value) {
      returnList.add(CalenderMessageType(i + 1, key, value));
    });
  }
  return returnList;
}