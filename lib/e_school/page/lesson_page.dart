import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/e_school/advanced_tiles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'e_school_course_webview.dart';

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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionPanelList.radio(
            animationDuration: Duration(milliseconds: 500),
            children: widget.tile
                .map((tile) => ExpansionPanelRadio(
                    value: tile.title,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) =>
                        ListTile(
                          title: Text(
                            tile.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                    body: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Tooltip(
                                showDuration: Duration(milliseconds: 500),
                                message: '前往課程公告',
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 6.0),
                                      minimumSize: Size(0.0, 0.0),
                                    ),
                                    child: Text("課程公告",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                    onPressed: () => null),
                              ),
                              // SizedBox(
                              //   width: 16.0,
                              // ),
                              Tooltip(
                                showDuration: Duration(milliseconds: 500),
                                message: '前往開始上課',
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 6.0),
                                      minimumSize: Size(0.0, 0.0),
                                    ),
                                    child: Text("開始上課",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                    onPressed: () => null),
                              ),
                              // SizedBox(
                              //   width: 16.0,
                              // ),
                              Tooltip(
                                showDuration: Duration(milliseconds: 500),
                                message: '前往成績資訊',
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 6.0),
                                      minimumSize: Size(0.0, 0.0),
                                    ),
                                    child: Text("成績資訊",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                    onPressed: () => null),
                              ),
                            ]),
                      ),
                    )))
                .toList(),
          );
        });
  }
}
