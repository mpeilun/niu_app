import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/e_school/advanced_tiles.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({
    Key? key,
  }) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final advancedTile = <AdvancedTile>[
    AdvancedTile(title: '課程1', workCount: '10', submitCount: '10'),
    AdvancedTile(title: '課程2', workCount: '10', submitCount: '9'),
    AdvancedTile(title: '課程3'),
    AdvancedTile(title: '課程4'),
    AdvancedTile(title: '課程5'),
    AdvancedTile(title: '課程6'),
    AdvancedTile(title: '課程7'),
    AdvancedTile(title: '課程8'),
    AdvancedTile(title: '課程9'),
    AdvancedTile(title: '課程10'),
    AdvancedTile(title: '課程11'),
    AdvancedTile(title: '課程12'),
    AdvancedTile(title: '課程13'),
  ];

  //title 放展開前的標題，tiles 裡的 title 放展開後的作業內容

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomLessonCard(tile: advancedTile);
  }
}

class CustomLessonCard extends StatefulWidget {
  const CustomLessonCard({
    Key? key,
    required this.tile,
  }) : super(key: key);

  final List<AdvancedTile> tile;

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
            animationDuration: Duration(milliseconds: 750),
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
