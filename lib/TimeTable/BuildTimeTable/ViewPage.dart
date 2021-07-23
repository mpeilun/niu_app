import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'ClassList.dart';
import 'Class.dart';

class ViewPage extends StatelessWidget {
  const ViewPage.build({
    required this.myTable,
  });
  final List<Class> myTable;
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


