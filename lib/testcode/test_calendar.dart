import 'package:flutter/material.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/service/CalendarMessage.dart';
import 'package:niu_app/service/SemesterDate.dart';

class TestCalendar extends StatefulWidget {
  final SemesterDate semester;
  TestCalendar({required this.semester});
  @override
  State<TestCalendar> createState() => _TestCalendarState();
}

class _TestCalendarState extends State<TestCalendar> {
  List<CalenderMessageType> calenderList = [];
  bool loadState = false;
  late SemesterDate semester = widget.semester;

  @override
  void initState() {
    super.initState();
    runGetCalenderList();
    print("GetCalenderList");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return loadState ? ModifyCalender(calenderMessage: calenderList.first,semester: semester,)
        : Container();
  }

  runGetCalenderList() async{
    calenderList = await getCalenderList();
    setState(() {
      if(calenderList.isNotEmpty){
        loadState = true;
      }else{
        Navigator.pop(context);
        showToast('無數據存在');
      }
    });
  }

}