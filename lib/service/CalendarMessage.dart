import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class ModifyCalender extends StatefulWidget {
  final CalenderMessageType calenderMessage;
  final SemesterDate semester;
  ModifyCalender({required this.calenderMessage,required this.semester});


  @override
  _ModifyCalenderState createState() => _ModifyCalenderState();
}

class _ModifyCalenderState extends State<ModifyCalender> {
  List<bool> isSelected = <bool>[false, false, false];
  List<String> chineseWeekDayNum = [
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
    "日"
  ];
  late Calendar calendar;
  late CalenderMessageType thisType;
  late SemesterDate semester;
  late String? calendarName;
  late String? calendarRange;
  late int calendarType;

  @override
  void initState() {
    super.initState();
    calendar = widget.calenderMessage.calendar;
    thisType=widget.calenderMessage;
    semester = widget.semester;
    calendarName = calendar.name();
    if(calendarName == "null")
      calendarName="";
    calendarRange = calendar.range();
    if(calendarRange == "null")
      calendarRange="";
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
              Text(
                  "${thisType._class.name} @ ${DateFormat("MM/dd").format(thisType.date(semester))}(${chineseWeekDayNum[thisType.date(semester).weekday-1]})",
                  style: TextStyle(fontSize: 18),
              ),
              //Text('$calendarName, $calendarRange', style: TextStyle(fontSize: 18),),
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
                    hintText: '請輸入名稱',
                  ),
                  onChanged: (text) {
                    if (text != "") {
                      calendarName!.replaceAll(",", "");
                    }
                    calendarName = text;
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
                      hintText: "請輸入內容",
                    ),
                    onChanged: (text) {
                      if (text != "") {
                        calendarRange!.replaceAll(",", "");
                      }
                      calendarRange = text;
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      WeekCalendar().del(widget.calenderMessage._class, widget.calenderMessage.week-1);
                      Navigator.pop(context);
                      showToast('刪除成功');
                    },
                    child: Icon(Icons.delete),
                  ),
                  SizedBox(width: 5,),
                  ElevatedButton(
                    onPressed: () {
                      WeekCalendar().push(widget.calenderMessage._class,
                          Calendar(calendarType, calendarName, calendarRange), widget.calenderMessage.week-1);
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