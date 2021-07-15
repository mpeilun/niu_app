class Class{
  //課名
  String name = "Default name";
  //老師
  String teacher = "Default teacher";
  //課的星期
  int weekDay = -1;
  //課的起迄
  int startTime = -1;
  int endTime = -1;
  //是否有同名的課
  Class? sameClass;
  ///<--普通建構子-->///
  Class(this.name,this.teacher,this.weekDay,this.startTime,this.endTime);
}