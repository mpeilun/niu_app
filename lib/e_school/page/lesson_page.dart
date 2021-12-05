import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/e_school/advanced_tiles.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:provider/provider.dart';

import 'e_school_announcement.dart';
import 'e_school_grade.dart';
import 'e_school_learning.dart';

class LessonPage extends StatefulWidget {
  final List<AdvancedTile> advancedTile;

  const LessonPage({
    Key? key,
    required this.advancedTile,
  }) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  late String url;

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
    return CustomLessonCard(tile: widget.advancedTile);
  }
}

class CustomLessonCard extends StatefulWidget {
  final List<AdvancedTile> tile;

  const CustomLessonCard({
    Key? key,
    required this.tile,
  }) : super(key: key);

  @override
  _CustomLessonCardState createState() => _CustomLessonCardState();
}

class _CustomLessonCardState extends State<CustomLessonCard> {
  bool delay = false;

  Future<void> runDelay() async {
    await Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        delay = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    runDelay();
  }

  @override
  Widget build(BuildContext context) {
    return delay
        ? ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              final themeChange = Provider.of<DarkThemeProvider>(context);
              return ExpansionPanelList.radio(
                animationDuration: Duration(milliseconds: 500),
                children: widget.tile
                    .map((tile) => ExpansionPanelRadio(
                        value: tile.title,
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context,
                                bool isExpanded) =>
                            ListTile(
                              title: Text(
                                tile.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                        body: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 24.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Tooltip(
                                    showDuration: Duration(milliseconds: 500),
                                    message: '前往課程公告',
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          // shape: RoundedRectangleBorder(
                                          //   borderRadius:
                                          //       BorderRadius.circular(18.0),
                                          // ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 8.0),
                                          minimumSize: Size(0.0, 0.0),
                                        ),
                                        child: Text("課程公告",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: themeChange.darkTheme
                                                    ? Colors.grey[200]
                                                    : Colors.white)),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ESchoolAnnouncement(
                                                          courseId:
                                                              tile.courseId,
                                                          advancedTile:
                                                              widget.tile),
                                                  maintainState: false));
                                        }),
                                  ),
                                  // SizedBox(
                                  //   width: 16.0,
                                  // ),
                                  Expanded(flex: 2, child: SizedBox()),

                                  Tooltip(
                                    showDuration: Duration(milliseconds: 500),
                                    message: '前往開始上課',
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          // primary: Theme.of(context).primaryColor,
                                          // shape: RoundedRectangleBorder(
                                          //   borderRadius:
                                          //   BorderRadius.circular(18.0),
                                          // ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 8.0),
                                          minimumSize: Size(0.0, 0.0),
                                        ),
                                        child: Text("開始上課",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: themeChange.darkTheme
                                                    ? Colors.grey[200]
                                                    : Colors.white)),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ESchoolLearning(
                                                          courseId:
                                                              tile.courseId,
                                                          courseName:
                                                              tile.title),
                                                  maintainState: false));
                                        }),
                                  ),
                                  // SizedBox(
                                  //   width: 16.0,
                                  // ),
                                  Expanded(flex: 2, child: SizedBox()),

                                  Tooltip(
                                    showDuration: Duration(milliseconds: 500),
                                    message: '前往成績資訊',
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          // primary: Theme.of(context).primaryColor,
                                          // shape: RoundedRectangleBorder(
                                          //   borderRadius:
                                          //   BorderRadius.circular(18.0),
                                          // ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 8.0),
                                          minimumSize: Size(0.0, 0.0),
                                        ),
                                        child: Text("成績資訊",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: themeChange.darkTheme
                                                    ? Colors.grey[200]
                                                    : Colors.white)),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ESchoolGrade(
                                                          courseId:
                                                              tile.courseId,
                                                          advancedTile:
                                                              widget.tile),
                                                  maintainState: false));
                                        }),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                ]),
                          ),
                        )))
                    .toList(),
              );
            })
        : NiuIconLoading(size: 80);
  }
}
