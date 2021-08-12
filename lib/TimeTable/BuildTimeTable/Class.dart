import 'package:flutter/material.dart';

class Class{
  //課名
  String? name = "Default name";
  //老師
  String? teacher = "Default teacher";
  //教室
  String? classroom = "Default classroom";
  //課的星期
  int weekDay = -1;
  //課的起迄
  int startTime = -1;
  int endTime = -1;
  /*
  //是否有同名的課
  Class? sameClass;
  */
  //課程的顏色
  Color? _color = Colors.white;
  Color? getColor(){
    return _color;
  }
  ///<--普通建構子-->///
  Class(this.name,this.teacher,this.classroom,this.weekDay,this.startTime,this.endTime);
  void setColor(Color? changeColor) {_color = changeColor;}
  String save(){
    return "Class($name,$teacher,$classroom,$weekDay,$startTime,$endTime)";
  }
}