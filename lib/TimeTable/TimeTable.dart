import 'package:flutter/material.dart';
import 'package:niu_app/class_timetable/timetable.dart';
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
  // SemesterDate a = SemesterDate();
  late var a;
  late var b;

  Future<bool> getIsFinish() async{
    a = SemesterDate();
    b = GetHTML(context);
    await a.getIsFinish();
    await b.getIsFinish();
    return true;
  }

  // List<Class> myTable = <Class>[
  //   Class("電子電路", "朱志明", "教416", 1, 2, 4),
  //   Class("工程數學", "黃朝曦", "教102", 1, 5, 5),
  //   Class("英文聽講", "待聘教師", "綜105", 1, 7, 8),
  //   Class("人工智慧導論", "林斯寅", "格406", 1, 9, 9),
  //   Class("GC服務管理", "黃麗君", "教214", 2, 3, 4),
  //   Class("人工智慧導論", "林斯寅", "格406", 2, 5, 6),
  //   Class("工程數學", "黃朝曦", "教102", 3, 3, 4),
  //   Class("離散數學", "吳汶涓", "綜202", 3, 7, 9),
  //   Class("GB台灣開發史", "陳政吉", "教105", 3, 10, 12),
  //   Class("國防", "teacher", "classroom", 4, 3, 4),
  //   Class("name", "teacher", "classroom", 4, 9, 10),
  //   Class("資訊安全導論", "陳麒元", "格406", 4, 5, 7),
  //   Class("微處理器系統","卓信宏","教416",5,1,3),
  // ];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIsFinish(), // the function to get your data from firebase or firestore
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.data == null) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("課表"),
                  centerTitle: true,
                ),
                body: NiuIconLoading(size: 80));
            //return loading widget
          } else {
            List<List<String?>> htmlCode = b.htmlCode;
            var temp = HtmlToClassList();
            List<Class> tempClassList = temp.classList(htmlCode);
            Map<Class, Calendar> calendarMap = b.calendarMap;
            return Timetable();
              // ViewPage.build(
              //   myTable: tempClassList,
              //   // myTable: myTable,
              //   date: a,
              //   calendarMap: calendarMap);
            //return the widget that you want to display after loading
          }
        });
  }

}
