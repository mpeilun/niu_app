import 'dart:convert';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import '../BuildTimeTable/Class.dart';
class Calendar{
  Calendar(int? type,String? name,String? range){
    if(type != null){
      typeEnable = true;
      _type = type;
    }
    if(name != null){
      nameEnable = true;
      _name = name;
    }
    if(range != null){
      rangeEnable = true;
      _range = range;
    }
  }
  bool typeEnable = false;
  late int _type;
  int type(){
    if(typeEnable)
      return _type;
    else
      return -1;
  }
  bool nameEnable = false;
  late String _name;
  String name(){
    if(nameEnable)
      return _name;
    else
      return "null";
  }
  bool rangeEnable = false;
  late String _range;
  String range(){
    if(rangeEnable)
      return _range;
    else
      return "null";
  }
  String save(){
    return "Calendar(" + type().toString() + "," + name() + "," + range() + ")";
  }
}

class WeekCalendar{
//List< Map<Class,Calendar> >
  List< Map<String,String> > saveList = [{Class("電子電路","朱志明","教416",1,2,4).save() : Calendar(1,null,null).save()}];
  void push(Class cl,Calendar ca) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int week = prefs.getInt("SelectWeek")!;
    if(week == -1)
      week = 0;
    List<String> saveList = await readMen();
    Map<String,String> tempMap = stringToMap(saveList[week]);
    tempMap[cl.save()] = ca.save();
    saveList[week] = mapToString(tempMap);
    prefs.setStringList("Calendar",saveList);
  }
  void setWeek(int week) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("SelectWeek",week);
    List<String> saveList = await readMen();
    print(
        saveList // {"Class(電子電路,朱志明,教416,1,2,4)":"Calendar(1,null,null)"}
    );
  }
  Map<String,String> stringToMap(String str){
    if(str.isNotEmpty)
      return Map<String, String>.from(json.decode(str));
    return {};
  }
  String mapToString(Map<String,String> map){
    if(map.isNotEmpty)
      return json.encode(map);
    return "";
  }
  Future<List<String>> readMen() async{
    List<String>firstList = ["","","","","","","","","","","","","","","","","","","","","","","",""];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tempList = prefs.getStringList("Calendar");
    List<String> returnList;
    if(tempList != null)
      returnList = tempList;
    else
      returnList = firstList;
    return returnList;
  }

}