import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:niu_app/TimeTable/BuildTimeTable/ClassCard.dart';
import 'package:niu_app/TimeTable/BuildTimeTable/NullClassCard.dart';

import 'ClassCard.dart';
import 'Class.dart';

class ClassList{
  List<dynamic> _classList;
  Map<String , Color> colorList = {}; //Color?
  List<StaggeredTile> _staggeredTiles = [];
  List<StaggeredTile> getStaggeredTile(){
    return _staggeredTiles;
  }
  List<Widget> _tiles = [];
  List<Widget> getTiles(){
    return _tiles;
  }
  List<List<bool>> tableInfo = []; //在某個禮拜某節是不是有課


  ClassList(this._classList){
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
    for(int i = 0; i < _classList.length; i++){
      while(time != _classList[i].startTime){
        int num = 0;
        for(int j = weekDay; j <= 5;j++){
          if(!tableInfo[j][time]){
            putNullClass();
            num++;
          }
        }
        print("add " + num.toString() + " for new line");
        time++;
        weekDay = 1;
      }
      int num = 0;
      for(int j = weekDay; j < _classList[i].weekDay;j++){
        if(!tableInfo[weekDay][time]) {
          putNullClass();
          num++;
        }
      }
      print("add " + num.toString() + " for space");
      print(_classList[i].name);
      putClass(_classList[i]);
      weekDay = _classList[i].weekDay+1;
      time = _classList[i].startTime;
      for(int j = _classList[i].startTime; j <= _classList[i].endTime; j++){
        tableInfo[_classList[i].weekDay][j] = true;
      }
    }
    for(int i = 1; i <= 5;i++){
      print(tableInfo[i]);
    }
  }

  ///<--有課程新增ClassCard到list裡-->///
  void putClass(Class thisClass){
    if( colorList[thisClass.name] == null){
      thisClass.setColor( colors[colorIndex] );
      colorList[thisClass.name.toString()] = colors[colorIndex++];
    }
    else {
      thisClass.setColor( colorList[thisClass.name] );
    }
    _tiles.add(ClassCard.build(thisClass : thisClass));
    _staggeredTiles.add(StaggeredTile.count(1, (thisClass.endTime - thisClass.startTime + 1).toDouble() ));
  }

  void putNullClass(){
    _tiles.add(NullClassCard.build());
    _staggeredTiles.add(StaggeredTile.count(1,1));
  }

}

int colorIndex = 0;
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