import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niu_app/service/SemesterDate.dart';
import 'package:niu_app/TimeTable/TimeTable.dart';
import 'BuildTimeTable/ClassList.dart';
import 'BuildTimeTable/Class.dart';
import 'Calendar/Calendar.dart';
class ViewPage extends StatefulWidget {
  const ViewPage.build({
    required this.myTable,
    required this.date,
    required this.calendarMap,
  });
  final List<Class> myTable;
  final SemesterDate date;
  final Map<Class,Calendar> calendarMap;
  @override
  _ViewPage createState() => new _ViewPage();
}
class _ViewPage extends State<ViewPage> {
  int week = -1;
  bool select = false;
  Map<Class,Calendar> calendarMap = {};
  @override
  Widget build(BuildContext context) {
    if(!select){
      week = widget.date.semesterWeek;
      if(week != -1)
        week--;
      calendarMap = widget.calendarMap;
      WeekCalendar().setWeek(week);
    }
    var _re = ClassList(widget.myTable,calendarMap,week);
    return Scaffold(
      appBar: AppBar(
        title: Text("課表"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            padding: const EdgeInsets.all(.0),
            itemBuilder: (context) => weekGetPopupMenu(context),
            onSelected: (String value) async{
              print('Week Selected : ' + value);
              week = int.parse(value)-1;
              calendarMap = await WeekCalendar().getCalendar(week);
              await WeekCalendar().setWeek(week);
              setState(() {
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            itemBuilder: (context) => settingGetPopupMenu(context),
            onSelected: (String value) async{
              print('onSelected : ' + value);
              if( value == "Reload"){
                clean(context);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("Calendar");
              }
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
          padding: const EdgeInsets.all(12),  //2*5課表+1時間
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

  settingGetPopupMenu(BuildContext context) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'Reload',
        child: Center(child: Text('清除緩存')),
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
    return Text('第' + chineseNum[num] + "週" ,style: TextStyle(fontSize: num < 10 ? 14 : 12),);
  }
  void clean(BuildContext context) async{
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


