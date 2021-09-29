import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../Calendar/Calendar.dart';
import 'ClassCard.dart';
import 'Class.dart';
import 'TimeCard.dart';
import 'WeekDayCard.dart';
import 'NullClassCard.dart';

class ClassList{
  int week;
  List<dynamic> _classList;
  Map<Class,Calendar> calendarMap;
  List<StaggeredTile> _staggeredTiles = [];
  List<StaggeredTile> getStaggeredTile(){
    return _staggeredTiles;
  }
  List<Widget> _tiles = [];
  List<Widget> getTiles(){
    return _tiles;
  }
  List<List<bool>> tableInfo = []; //在某個禮拜某節是不是有課
  //arr[weekday][classNum]
  HashMap colorMap = new HashMap<String,Color>();
  int colorIndex = 0;

  ClassList(this._classList,this.calendarMap,this.week){

    ///<--執行前對list的sort&tableInfo的初始化-->///
    //排序
    _classList.sort((left,right)=>left.weekDay.compareTo(right.weekDay));
    _classList.sort((left,right)=>left.startTime.compareTo(right.startTime));
    //tableInfo的初始化
    for(int i = 0;i<6;i++){
      tableInfo.add([false,false,false,false,false,false,false,false,false,false,false,false]);
    }
    ///<--產生pageList-->///
    int weekDay = 1;
    int time = 0;
    //星期
    _tiles.add(NullClassCard.build());
    _staggeredTiles.add(StaggeredTile.count(1,1.1));
    for(int i = 0; i < 5; i++){
      putWeekDay(i);
    }
    putTime(0);
    for(int i = 0; i < _classList.length; i++){
      //換行
      while(time != _classList[i].startTime){
        for(int j = weekDay; j <= 5;j++){
          if(!tableInfo[j][time]){
            putNullClass();
          }
        }
        time++;
        weekDay = 1;
        putTime(time);
      }
      //同行空格
      for(int j = weekDay; j < _classList[i].weekDay;j++){
        if(!tableInfo[j][time]) {
          putNullClass();
        }
      }
      putClass(_classList[i],calendarMap);
      weekDay = _classList[i].weekDay+1;
      time = _classList[i].startTime;
      //在tableInfo裡標記課程
      for(int j = _classList[i].startTime; j <= _classList[i].endTime; j++){
        tableInfo[_classList[i].weekDay][j] = true;
        //print( "Have Class " + _classList[i].weekDay.toString() + " " + j.toString() + " because " + _classList[i].name);
      }
      //todo: 最後一節偵測 補完時間
    }
  }

  ///<--有課程新增ClassCard到list裡-->///
  void putClass(Class thisClass,Map<Class,Calendar> calendarMap){
    String saveString = thisClass.save();
    if(colorMap[saveString] != null){
      thisClass.setColor(colorMap[saveString]);
    }else{
      colorMap[saveString] = colors[colorIndex++];
      thisClass.setColor(colorMap[saveString]);
    }
    Calendar calendar = Calendar(null,null,null);
    calendarMap.forEach((key, value) {
      if(key.equal(thisClass)){
        calendar = value;
        return;
      }
    });
    _tiles.add(ClassCard.build(thisClass : thisClass, calendar : calendar,week : week));
    _staggeredTiles.add(StaggeredTile.count(2, (thisClass.endTime - thisClass.startTime + 1).toDouble()*2.1 )); //*2ㄉ寬 *2.1高
  }
  ///<--沒課程新增NullClassCard到list裡-->///
  void putNullClass(){
    _tiles.add(NullClassCard.build());
    _staggeredTiles.add(StaggeredTile.count(2,2.1)); //*2ㄉ寬 *2.1高
  }
  void putTime(int time){
    _tiles.add(TimeCard.build( thisTime: time));
    _staggeredTiles.add(StaggeredTile.count(1,2.1)); //*2.1高
  }
  void putWeekDay(int day){
    _tiles.add(WeekDayCard.build( thisDay: day));
    _staggeredTiles.add(StaggeredTile.count(2,1.1)); //*2.1高
  }

}

List<Color> colors = <Color>[
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.amber,
  Colors.cyan,
  Colors.purple,
  Colors.indigo,
  Colors.greenAccent,
  Colors.lightBlueAccent,
  Colors.tealAccent,
  Colors.cyanAccent
];
