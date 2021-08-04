import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niu_app/service/SemesterDate.dart';
import 'package:niu_app/TimeTable/TimeTable.dart';
import 'BuildTimeTable/ClassList.dart';
import 'BuildTimeTable/Class.dart';
class ViewPage extends StatefulWidget {
  const ViewPage.build({
    required this.myTable,
    required this.date,
  });
  final List<Class> myTable;
  final SemesterDate date;
  @override
  _ViewPage createState() => new _ViewPage();
}
class _ViewPage extends State<ViewPage> {
  int week = -1;
  bool select = false;
  @override
  Widget build(BuildContext context) {
    if(!select)
      week = widget.date.semesterWeek;
    String dropdownValue = 'One';
    var _re = ClassList(widget.myTable);
    return Scaffold(
      appBar: AppBar(
        title: Text("課表"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => weekGetPopupMenu(context),
            onSelected: (String value) {
              print('onSelected : ' + value);
              setState(() {
                week = int.parse(value)-1;
                select = true;
              });
            },
            onCanceled: () {
              print('onCanceled');
            },
//      child: RaisedButton(onPressed: (){},child: Text('选择'),),
            icon: weekNumText(week),
            iconSize : 36,
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => setingGetPopupMenu(context),
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
          ),
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

  setingGetPopupMenu(BuildContext context) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'Reload',
        child: Text('重新獲取課表'),
      ),
    ];
  }
  weekGetPopupMenu(BuildContext context) {
    List<PopupMenuEntry<String>> item = [];
    for(int i = 0;i < 18;i++)
      item.add(
        PopupMenuItem<String>(
          value: (i+1).toString(),
          child: _weekNumText(i),
        ),
      );
    return item;
  }
  _weekNumText(int num){
    if(num == -1)
      return Text("寒暑假",style: TextStyle(fontSize: 16));
    List<String> chineseNum = <String>[
      "一","二","三","四","五","六","七","八","九","十","十一","十二","十三","十四","十五","十六","十七","十八"
    ];
    return Text('第' + chineseNum[num] + "週" ,style: TextStyle(fontSize: 16));
  }
  weekNumText(int num){
    if(num == -1)
      return Text("寒暑假",style: TextStyle(fontSize: 12));
    List<String> chineseNum = <String>[
      "一","二","三","四","五","六","七","八","九","十","十一","十二","十三","十四","十五","十六","十七","十八"
    ];
    return Text('第' + chineseNum[num] + "週" ,style: TextStyle(fontSize: num < 10 ? 12 : 9),);
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


