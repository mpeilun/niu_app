import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'ClassList.dart';
import 'NullClassCard.dart';
import 'ClassCard.dart';
import 'Class.dart';

class ViewPage extends StatelessWidget {
  const ViewPage.build();

  @override
  Widget build(BuildContext context) {
    var _re = ClassList(_list);
    return Scaffold(
      appBar: AppBar(
        title: Text("課表"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(5),
          child: StaggeredGridView.count(
            crossAxisCount: 5,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            //staggeredTiles: _re.getStaggeredTile(),
            staggeredTiles: _staggeredTiles,
            //size
            //children: _re.getTiles(), //物件
            children: _tiles, //物件
          )
      ),
    );
  }
}

Class temp = new Class("生態與環境變遷","徐明藤","101",1,1,1);
Class temp1 = new Class("生態與環境變遷1","徐明藤","101",1,1,1);
List<Class> _list = <Class>[
  temp,temp,temp,temp1
];


List<StaggeredTile> _staggeredTiles = <StaggeredTile>[
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 2),
];
List<Widget> _tiles = <Widget>[
  ClassCard.build(thisClass : temp),
  NullClassCard.build(),
  ClassCard.build(thisClass : temp),
  ClassCard.build(thisClass : temp),
  ClassCard.build(thisClass : temp),
  ClassCard.build(thisClass : temp),
  ClassCard.build(thisClass : temp),
  ClassCard.build(thisClass : temp),
  ClassCard.build(thisClass : temp),
  ClassCard.build(thisClass : temp),
];
