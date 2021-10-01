import 'package:flutter/material.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/service/SemesterDate.dart';
import 'ViewPage.dart';
import './BuildTimeTable/Class.dart';
import './GetTimeTable/GetHTML.dart';
import './GetTimeTable/HtmlToClassList.dart';
import './Calendar/Calendar.dart';

class TimeTable extends StatefulWidget {
  TimeTable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  SemesterDate a = SemesterDate();
  var b = getHTML();
/*
  List<Class> myTable = <Class>[
    Class("電子電路", "朱志明", "教416", 1, 2, 4),
    Class("工程數學", "黃朝曦", "教102", 1, 5, 5),
    Class("英文聽講", "待聘教師", "綜105", 1, 7, 8),
    Class("人工智慧導論", "林斯寅", "格406", 1, 9, 9),
    Class("GC服務管理", "黃麗君", "教214", 2, 3, 4),
    Class("人工智慧導論", "林斯寅", "格406", 2, 5, 6),
    Class("工程數學", "黃朝曦", "教102", 3, 3, 4),
    Class("離散數學", "吳汶涓", "綜202", 3, 7, 9),
    Class("GB台灣開發史", "陳政吉", "教105", 3, 10, 11),
    Class("資訊安全導論", "陳麒元", "格406", 4, 5, 7),
    Class("微處理器系統", "卓信宏", "教416", 5, 2, 4)
  ];
*/
  @override
  Widget build(BuildContext context) {
    a.getIsFinish();
    return FutureBuilder(
        future: b
            .getIsFinish(), // the function to get your data from firebase or firestore
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.data == null) {
            return NiuIconLoading(size: 80);
            //return loading widget
          } else {
            List<List<String?>> htmlCode = b.htmlCode;
            var temp = HtmlToClassList();
            List<Class> tempClassList = temp.classList(htmlCode);
            Map<Class, Calendar> calendarMap = b.calendarMap;
            return ViewPage.build(
                myTable: tempClassList, date: a, calendarMap: calendarMap);
            //return the widget that you want to display after loading
          }
        });
  }

  void printClassList(List<Class> ClassList) {
    for (int i = 0; i < ClassList.length; i++)
      print(ClassList[i].name.toString() +
          " " +
          ClassList[i].teacher.toString() +
          " " +
          ClassList[i].classroom.toString() +
          " " +
          ClassList[i].weekDay.toString() +
          " " +
          ClassList[i].startTime.toString() +
          " " +
          ClassList[i].endTime.toString());
  }
}
