import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart' as prefix;
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart';

import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/service/CalendarMessage.dart';
import 'package:niu_app/service/SemesterDate.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<CalenderMessageType> calenderMsg = [];
  SemesterDate a = SemesterDate();
  CalenderMessage calenderMessage = new CalenderMessage();
  Future<bool> isFinish() async {
    calenderMsg = await calenderMessage.getList();
    await a.getIsFinish();
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: FutureBuilder(
            future: isFinish(),
            builder: (BuildContext context, AsyncSnapshot snap) {
              calenderMsg.forEach((element) {
                print(element.calendar.name() +
                    element.date(a).toString() +
                    element.calendar.save());
              });

              return calenderMessage.set(context, calenderMsg.first);
            }),
      ),
    );
  }
}
