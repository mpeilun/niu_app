import 'package:dio/dio.dart';
import 'package:week_of_year/week_of_year.dart';
import 'dart:convert';

class SemesterDate{

  ///<--Json的索引列-->///
  List<String> index = [
    "start_year",
    "start_month",
    "start_day",
    "end_year",
    "end_month",
    "end_day",
    "final_semester"
  ];

  ///<--現在的日期-->///
  int? nowYear;
  int? nowMonths;
  int? nowDay;

  ///<--現在的學期-->///
  /// null=沒初始化 ///
  /// out=不在學期中///
  String nowSemester = "null";

  ///<--學期起迄-->///
  /// -1=不在學期中///
  /// -2=尚未初始化///
  int semesterStartYear = -2;
  int semesterStartMonths = -2;
  int semesterStartDay = -2;

  int semesterEndYear = -2;
  int semesterEndMonths = -2;
  int semesterEndDay = -2;

  int semesterWeek = -2;
  Future<int> getSemesterWeek() async {
    if(semesterWeek == -2)
      await semester();
    return semesterWeek;
  }

  SemesterDate(){
    DateTime now = DateTime.now();
    nowYear = now.year;
    nowMonths = now.month;
    nowDay = now.day;
    semester();
  }
  Future<void> semester() async{
    var jsonString = await Dio().get('https://my-json-server.typicode.com/ken6078/NiuSemesterJSON/db');
    Map<String, dynamic> semesterJSON = json.decode(jsonString.toString());
    getNowWeek(semesterJSON,109,1);
    //print(semesterWeek);
  }
  void getNowWeek(Map<String, dynamic> semesterJSON,int year,int semester){
    if (semester == 3) {
      getNowWeek(semesterJSON, year + 1, 1);
      return;
    }
    String thisSemester = "d" + year.toString() + "-" + semester.toString();
    int startYear = int.parse(semesterJSON[thisSemester][index[0]]);
    int startMonth = int.parse(semesterJSON[thisSemester][index[1]]);
    int startDay = int.parse(semesterJSON[thisSemester][index[2]]);
    int endYear = int.parse(semesterJSON[thisSemester][index[3]]);
    int endMonth = int.parse(semesterJSON[thisSemester][index[4]]);
    int endDay = int.parse(semesterJSON[thisSemester][index[5]]);
    DateTime now = DateTime.now();
    //DateTime now = DateTime.utc(2020,09,15);
    DateTime semesterStartTime = DateTime.utc(startYear,startMonth,startDay);
    DateTime semesterEndTime = DateTime.utc(endYear,endMonth,endDay);
    if( (now.isAfter(semesterStartTime) || now.isAtSameMomentAs(semesterStartTime) )  && ( semesterEndTime.isAfter(now) || now.isAtSameMomentAs(semesterStartTime) ) ){
      semesterStartYear = startYear;
      semesterStartMonths = startMonth;
      semesterStartDay = startDay;
      semesterEndYear = endYear;
      semesterEndMonths = endMonth;
      semesterEndDay = endDay;
      semesterWeek = now.weekOfYear - semesterStartTime.weekOfYear + 1;
      if(semesterWeek < 0)
        semesterWeek += 52;
    }else if( now.isBefore(semesterStartTime) ){
      outOfSemester();
    }else if( semesterJSON[thisSemester][index[6]] == "false" ){
      getNowWeek(semesterJSON, year, semester+1);
    }else{
      outOfSemester();
    }
    return;
  }
  void outOfSemester(){
    semesterStartYear = -1;
    semesterStartMonths = -1;
    semesterStartDay = -1;
    semesterEndYear = -1;
    semesterEndMonths = -1;
    semesterEndDay = -1;
    semesterWeek = -1;
    nowSemester = "out";
  }
}