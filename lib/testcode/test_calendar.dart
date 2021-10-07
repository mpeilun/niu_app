import 'package:flutter/material.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/service/CalendarMessage.dart';

class TestCalendar extends StatefulWidget {
  @override
  State<TestCalendar> createState() => _TestCalendarState();
}

class _TestCalendarState extends State<TestCalendar> {
  List<CalenderMessageType> calenderList = [];
  bool loadState = false;

  @override
  void initState() {
    super.initState();
    runGetCalenderList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return loadState ? ModifyCalender(calenderMessage: calenderList.first) : Container();
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