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
    var _re = ClassList(myTable);
    return Scaffold(
      appBar: AppBar(
        title: Text("課表"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(11),  //2*5課表+1時間
          child: StaggeredGridView.count(
            crossAxisCount: 11,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            staggeredTiles: _re.getStaggeredTile(),
            //staggeredTiles: _staggeredTiles,
            //size
            children: _re.getTiles(), //物件
            //children: _tiles, //物件
          )
      ),
    );
  }
}


List<Class> myTable = <Class>[
  Class("電子電路","朱志明","教416",1,2,4),
  Class("工程數學","黃朝曦","教102",1,5,5),
  Class("英文聽講","待聘教師","綜105",1,7,8),
  Class("人工智慧導論","林斯寅","格406",1,9,9),
  Class("GC服務管理","黃麗君","教214",2,3,4),
  Class("人工智慧導論","林斯寅","格406",2,5,6),
  Class("工程數學","黃朝曦","教102",3,3,4),
  Class("離散數學","吳汶涓","綜202",3,7,9),
  Class("GB台灣開發史","陳政吉","教105",3,10,11),
  Class("資訊安全導論","陳麒元","格406",4,5,7),
  Class("微處理器系統","卓信宏","教416",5,2,4)
];


Class nullClass = new Class(null,null,null,-1,-1,-1);
Class temp = new Class("生態與環境變遷","徐明藤","101",1,1,1);
Class temp1 = new Class("生態與環境變遷1","徐明藤","101",1,1,1);
Class temp2 = new Class("國文","陳頭疼","102",1,1,1);
List<Class> _list = <Class>[
  temp,nullClass,temp2,temp,temp1
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
