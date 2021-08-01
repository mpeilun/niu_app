import 'package:flutter/material.dart';
import 'package:niu_app/e_school/advanced_tiles.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({
    Key? key,
  }) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final advancedTile = <AdvancedTile>[
    AdvancedTile(
        title: '課程1',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(
        title: '課程2',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(
        title: '課程3',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(
        title: '課程4',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
  ];

  //title 放展開前的標題，tiles 裡的 title 放展開後的作業內容

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList.radio(
        children:
        advancedTile.
        map((tile) => ExpansionPanelRadio(
            value: tile.title,
            canTapOnHeader: true,
            headerBuilder: (BuildContext contet, bool isExpanded) => buildListTile(tile)
            , body: Column(
          children: tile.tiles.map(buildListTile).toList(),
        )
        )
        ).toList(),
      ),
    );
  }

  ListTile buildListTile(AdvancedTile tile) {
    return ListTile(
      leading: tile.icon != null ? Icon(tile.icon) : null,
      title: Text(tile.title),
    );
  }
}
