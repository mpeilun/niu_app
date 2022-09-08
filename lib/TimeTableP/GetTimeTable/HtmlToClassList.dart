import 'package:niu_app/TimeTableP/BuildTimeTable/Class.dart';
class HtmlToClassList{
  HtmlToClassList();
  int weekDayNum = 6;
  int classNum = 14;
  List<List<bool>> haveClass = [];
  List<Class> classList(List<List<String?>> htmlCode) {// arr[classNum][weekDayNum]
    for(int i = 0; i < 14; i++)
      haveClass.add([false,false,false,false,false,false]);
    List<Class> _classList = <Class>[];
    for(int i = 0; i < classNum; i++){
      for(int j = 0; j < weekDayNum; j++){
        if(htmlCode[i][j] == null || haveClass[i][j])
          continue;
        var thisClass = TempClass(htmlCode[i][j].toString());
        int startTime = i;
        int endTime = i;
        int index = i+1;
        while(index<classNum){
          if(htmlCode[index][j] == null)
            break;
          if(thisClass.equal(TempClass(htmlCode[index][j].toString()))){
            haveClass[index][j] = true;
            endTime = index++;
          }
          else
            break;
        }
        _classList.add(thisClass.create(j+1, startTime, endTime));
      }
    }
    return _classList;
  }
}

class TempClass{
  TempClass(String html){
    set(html);
  }
  String teacher = "";
  String className = "";
  String classroom = "";
  void set(String html){
    teacher = html.substring(0,html.indexOf("<br>"));
    className = html.substring(html.indexOf("<br>")+4,html.indexOf("<br>",html.indexOf("<br>")+1));
    classroom = html.substring(html.indexOf("<br>",html.indexOf("<br>")+1)+4);
  }
  bool equal(TempClass temp){
    return this.className == temp.className;
  }
  Class create(int weekDay,int startTime,int endTime){
    return Class(className,teacher,classroom,weekDay,startTime,endTime);
  }
}