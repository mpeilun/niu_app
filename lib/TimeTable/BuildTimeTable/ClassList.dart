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


  ClassList(this._classList){
    int colorIndex = 0;
    for(int i = 0; i < _classList.length; i++){
      if(_classList[i].teacher == null){
        _tiles.add(NullClassCard.build());
        _staggeredTiles.add(StaggeredTile.count(1, 1));
      }else{
        if( colorList[_classList[i].name] == null){
          _classList[i].setColor( colors[colorIndex] );
          colorList[_classList[i].name] = colors[colorIndex++];
        }
        else {
          _classList[i].setColor( colorList[_classList[i].name] );
        }
        _tiles.add(ClassCard.build(thisClass : _classList[i]));
        _staggeredTiles.add(StaggeredTile.count(1, 2));
      }

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