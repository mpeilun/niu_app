import 'package:flutter/material.dart';
import 'package:niu_app/TimeTable/Calendar/Calendar.dart';
import 'package:niu_app/TimeTable/BuildTimeTable/Class.dart';
import 'package:niu_app/service/SemesterDate.dart';
class CalenderMessage{
  void set(BuildContext context,CalenderMessageType id){

  }
}
class CalenderMessageType{
  CalenderMessageType(this.week,this._class,this.calendar);
  int week;
  Class _class;
  Calendar calendar;
  DateTime date(SemesterDate semester){
    if(semester.semesterStartDay == -1)
      print("semester Error");
    DateTime date = DateTime.utc(semester.semesterStartYear, semester.semesterStartMonths, semester.semesterStartDay);
    date = date.add(Duration(days: ((week-1)*7+_class.weekDay-1)));
    return date;
  }
}