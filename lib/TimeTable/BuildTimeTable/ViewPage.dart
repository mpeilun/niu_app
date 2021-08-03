import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niu_app/service/SemesterDate.dart';
import 'package:niu_app/TimeTable/TimeTable.dart';
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
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => _getPopupMenu(context),
            onSelected: (String value) {
              print('onSelected : ' + value);
              if( value == "Reload")
                reload(context);
            },
            onCanceled: () {
              print('onCanceled');
            },
//      child: RaisedButton(onPressed: (){},child: Text('选择'),),
            icon: Icon(Icons.reorder),
          )
        ],
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

  _getPopupMenu(BuildContext context) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'Reload',
        child: Text('重新獲取課表'),
      ),
    ];
  }

  void reload(BuildContext context) async{
    SemesterDate date = SemesterDate();
    await date.getIsFinish();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove( prefs.getString("id").toString() + "TimeTable" + date.nowSemester);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TimeTable(),
            maintainState: false));
  }
}


