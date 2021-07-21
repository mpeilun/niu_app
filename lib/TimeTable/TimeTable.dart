import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:niu_app/service/SemesterDate.dart';
import './BuildTimeTable/ViewPage.dart';
import 'Class.dart';
class TimeTable extends StatefulWidget {
  TimeTable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  var a = SemesterDate;
  @override
  Widget build(BuildContext context) {
    return ViewPage.build(myTable : myTable);
  }
}

List<Class> myTable = <Class>[
  Class("電子電路","朱志明","教416",1,2,4),
  Class("工程數學","黃朝曦","教102",1,5,5),
  Class("英文聽講","待聘教師","綜105",1,7,8),
  Class("人工智慧導論","林斯寅","格406",1,9,9),
  Class("GC服務管理","黃麗君","教214",2,3,4),
  Class("人工智慧導論","林斯寅","格406",2,5,6),
  Class("工程數學","黃朝曦","教102",3,3,4),
  Class("離散數學","吳汶涓","綜202",3,7,9),
  Class("GB台灣開發史","陳政吉","教105",3,10,11),
  Class("資訊安全導論","陳麒元","格406",4,5,7),
  Class("微處理器系統","卓信宏","教416",5,2,4)
];