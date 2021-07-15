import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:niu_app/TimeTable/BuildTimeTable/ClassCard.dart';

import 'ClassCard.dart';
import 'Class.dart';

class ClassList{
  List<Class> _classList;
  Map<String , Color> colorList = {}; //Color?
  List<StaggeredTile> _staggeredTiles = [];
  List<StaggeredTile> getStaggeredTile(){
    return _staggeredTiles;
  }
  List<Widget> _tiles = [];
  List<Widget> getTiles(){
    return _tiles;
  }


  ClassList(this._classList){
    int colorIndex = 0;
    for(int i = 0; i < _classList.length; i++){
      Color? temp = colorList[_classList[i].name] == null ? colorList[_classList[i].name] : Colors.white;
      if( colorList[_classList[i].name] == null){
        _classList[i].setColor( colors[colorIndex] );
        colorList[_classList[i].name] = colors[colorIndex++];
      }
      else {
        _classList[i].setColor( temp );
      }
      _tiles.add(ClassCard.build(thisClass : _classList[i]));
      _staggeredTiles.add(StaggeredTile.count(1, 2));
    }
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
];