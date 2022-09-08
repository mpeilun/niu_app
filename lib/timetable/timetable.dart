import 'package:flutter/material.dart';
import 'package:niu_app/timetable/getData.dart';
import 'package:niu_app/timetable/timetable_body.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/timetable/timetable_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeTable extends StatefulWidget {
  TimeTable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  // SemesterDate a = SemesterDate();
  late var getData;
  late List<List<TimetableClass>> timetableData;

  Future<bool> getIsFinish() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getData = GetHTML(context);
    if (prefs.getStringList(prefs.getString("id").toString() + "TimeTable") ==
        null) {
      print("Get from web");
      await getData.getFromWeb();
      print("Web load finish!");
    }

    print("Get from local");
    timetableData = await getData.getFromLocal();
    print("Local load finish!");
    await Future.delayed(Duration(milliseconds: 100));
    print("Load finish!");

    for (int i = 0; i < 14; i++) {
      print(timetableData[i].map((e) => e.teacher).toList());
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIsFinish(),
        // the function to get your data from firebase or firestore
        builder: (BuildContext context, AsyncSnapshot snap) {
          return Scaffold(
              appBar: AppBar(
                title: Text("課表"),
                centerTitle: true,
              ),
              body: (snap.data == null)
                  ? NiuIconLoading(size: 80)
                  : TimetableBody(
                      timetableData: timetableData,
                    ));
          //return loading widget
        });
  }
}
