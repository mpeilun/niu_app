import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../Calendar/Calendar.dart';
import 'ClassCard.dart';
import 'Class.dart';
import 'TimeCard.dart';
import 'WeekDayCard.dart';
import 'NullClassCard.dart';

class ClassList {
  int week;
  List<dynamic> _classList;
  Map<Class, Calendar> calendarMap;
  List<StaggeredTile> _staggeredTiles = [];
  List<StaggeredTile> getStaggeredTile() {
    return _staggeredTiles;
  }

  List<Widget> _tiles = [];
  List<Widget> getTiles() {
    return _tiles;
  }

  List<List<bool>> tableInfo = []; //在某個禮拜某節是不是有課
  //arr[weekday][classNum]
  HashMap colorMap = new HashMap<String, Color>();
  int colorIndex = 0;

  ClassList(this._classList, this.calendarMap, this.week) {
    ///<--執行前對list的sort&tableInfo的初始化-->///
    //排序
    _classList.sort((left, right) => left.weekDay.compareTo(right.weekDay));
    _classList.sort((left, right) => left.startTime.compareTo(right.startTime));
    //tableInfo的初始化
    for (int i = 0; i < 6; i++) {
      tableInfo.add([
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false
      ]);
    }

    ///<--產生pageList-->///
    int weekDay = 1;
    int time = 0;
    int endTime = 0;
    //星期
    _tiles.add(NullClassCard.build());
    _staggeredTiles.add(StaggeredTile.count(1, 1.1));
    for (int i = 0; i < 5; i++) {
      putWeekDay(i);
    }
    putTime(0);
    for (int i = 0; i < _classList.length; i++) {
      //print(_classList[i].save());
      if (endTime < _classList[i].endTime) endTime = _classList[i].endTime;
      //換行
      while (time != _classList[i].startTime) {
        for (int j = weekDay; j <= 5; j++) {
          if (!tableInfo[j][time]) {
            putNullClass();
          }
        }
        time++;
        weekDay = 1;
        putTime(time);
      }
      //同行空格
      for (int j = weekDay; j < _classList[i].weekDay; j++) {
        if (!tableInfo[j][time]) {
          putNullClass();
        }
      }
      putClass(_classList[i], calendarMap);
      weekDay = _classList[i].weekDay + 1;
      time = _classList[i].startTime;
      //在tableInfo裡標記課程
      for (int j = _classList[i].startTime; j <= _classList[i].endTime; j++) {
        tableInfo[_classList[i].weekDay][j] = true;
        //print( "Have Class " + _classList[i].weekDay.toString() + " " + j.toString() + " because " + _classList[i].name);
      }
      //最後一節偵測 補完時間
      if (i == _classList.length - 1) {
        for (int j = _classList[i].weekDay + 1; j < 5; j++)
          if (!tableInfo[j][time]) putNullClass();
        for (int j = time + 1; j <= endTime; j++) {
          putTime(j);
          for (int k = 1; k <= 5; k++) if (!tableInfo[k][j]) putNullClass();
        }
      }
    }
  }

  ///<--有課程新增ClassCard到list裡-->///
  void putClass(Class thisClass, Map<Class, Calendar> calendarMap) {
    String className = thisClass.getName();
    if (colorIndex == colors.length) colorIndex = 0;
    if (colorMap[className] != null) {
      thisClass.setColor(colorMap[className]);
    } else {
      colorMap[className] = colors[colorIndex++];
      thisClass.setColor(colorMap[className]);
    }
    Calendar calendar = Calendar(null, null, null);
    calendarMap.forEach((key, value) {
      if (key.equal(thisClass)) {
        calendar = value;
        return;
      }
    });
    _tiles.add(
        ClassCard.build(thisClass: thisClass, calendar: calendar, week: week));
    _staggeredTiles.add(StaggeredTile.count(
        2,
        (thisClass.endTime - thisClass.startTime + 1).toDouble() *
            2.1)); //*2ㄉ寬 *2.1高
  }

  ///<--沒課程新增NullClassCard到list裡-->///
  void putNullClass() {
    _tiles.add(NullClassCard.build());
    _staggeredTiles.add(StaggeredTile.count(2, 2.1)); //*2ㄉ寬 *2.1高
  }

  void putTime(int time) {
    _tiles.add(TimeCard.build(thisTime: time));
    _staggeredTiles.add(StaggeredTile.count(1, 2.1)); //*2.1高
  }

  void putWeekDay(int day) {
    _tiles.add(WeekDayCard.build(thisDay: day));
    _staggeredTiles.add(StaggeredTile.count(2, 1.1)); //*2.1高
  }
}

List<Color> colors = <Color>[
  Color(0xff2364AA).withOpacity(0.7),
  //Color(0xff3085C2).withOpacity(0.7),
  Color(0xff3DA5D9).withOpacity(0.7),
  //Color(0xff58B2C9).withOpacity(0.7),
  Color(0xff73BFB8).withOpacity(0.7),
  Color(0xffB9C35D).withOpacity(0.7),
  Color(0xffFEC601).withOpacity(0.7),
  Color(0xffF49D0C).withOpacity(0.7),
  Color(0xffEF8812).withOpacity(0.7),
  Color(0xffEA7317).withOpacity(0.7),
  //Color(0xff264653).withOpacity(0.7),
  Color(0xff287271).withOpacity(0.7),
  Color(0xff2A9D8F).withOpacity(0.7),
  Color(0xff8AB17D).withOpacity(0.7),
  Color(0xffBABB74).withOpacity(0.7),
  Color(0xffE9C46A).withOpacity(0.7),
  Color(0xffEFB366).withOpacity(0.7),
  Color(0xffF4A261).withOpacity(0.7),
  Color(0xffEE8959).withOpacity(0.7),
  Color(0xffE76F51).withOpacity(0.7),
];

/*
  Color(0xED71D2D4),
  Color(0xEE71B8D4),
  Color(0xEE71A6D4),
  Color(0xEE7871D4),
  Color(0xEEAE71D4),
  Color(0xEED471C7),
  Color(0xEED47190),
  Color(0xEED47171),
  Color(0xEED49971),
  Color(0xEED4BF71),
  Color(0xEEB1D471),
  Color(0xEE71D473),
  Color(0xEE71D4C5),
 */
/*
  Color(0x8071D2D4),
  Color(0x8071B8D4),
  Color(0x8071A6D4),
  Color(0x807871D4),
  Color(0x80AE71D4),
  Color(0x80D471C7),
  Color(0x80D47190),
  Color(0x80D47171),
  Color(0x80D49971),
  Color(0x80D4BF71),
  Color(0x80B1D471),
  Color(0x8071D473),
  Color(0x8071D4C5),
 */
