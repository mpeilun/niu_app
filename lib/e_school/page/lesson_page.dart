import 'package:flutter/material.dart';
import 'package:NationalIlanUniversityApp/e_school/advanced_tiles.dart';


class LessonPage extends StatefulWidget {
  const LessonPage({
    Key? key,
  }) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final advancedTile = <AdvancedTile>[
    AdvancedTile(title: '課程1', tiles: [
      AdvancedTile(
        title: '作業1',
        isSubmit: true,
      ),
      AdvancedTile(
        title: '作業2',
        isSubmit: true,
      ),
      AdvancedTile(
        title: '作業3',
        isSubmit: true,
      ),
      AdvancedTile(title: '作業4'),
    ]),
    AdvancedTile(title: '課程2', tiles: [
      AdvancedTile(
        title: '作業1',
        isSubmit: true,
      ),
      AdvancedTile(
        title: '作業2',
        isSubmit: true,
      ),
      AdvancedTile(
        title: '作業3',
        isSubmit: true,
      ),
      AdvancedTile(
        title: '作業4',
        isSubmit: true,
      ),
      AdvancedTile(
        title: '作業5',
        isSubmit: true,
      ),
    ]),
    AdvancedTile(title: '課程3', tiles: [
      AdvancedTile(
        title: '作業1',
        isSubmit: true,
      ),
      AdvancedTile(title: '作業2')
    ]),
    AdvancedTile(
        title: '課程4',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(
        title: '課程5',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(
        title: '課程6',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(
        title: '課程7',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(title: '課程8', tiles: [
      AdvancedTile(
        title: '作業1',
        isSubmit: true,
      ),
      AdvancedTile(title: '作業2')
    ]),
    AdvancedTile(
        title: '課程9',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(
        title: '課程10',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(
        title: '課程11',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(
        title: '課程12',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(
        title: '課程13',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
    AdvancedTile(
        title: '課程14',
        tiles: [AdvancedTile(title: '作業1'), AdvancedTile(title: '作業2')]),
  ];

  //title 放展開前的標題，tiles 裡的 title 放展開後的作業內容

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionPanelList.radio(
        children:
        advancedTile.
        map((tile) =>
            ExpansionPanelRadio(
                value: tile.title,
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) =>
                    buildListTile(tile)
                , body: Column(
              children: tile.tiles.map(buildListTile).toList(),
            )
            )
        ).toList(),
      );}
    );
  }

  ListTile buildListTile(AdvancedTile tile) {
    return ListTile(
      leading: tile.icon != null ? Icon(tile.icon) : null,
      title: Text(tile.title),
    );
  }
}
