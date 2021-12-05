import 'package:flutter/material.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:provider/provider.dart';

import '../advanced_tiles.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({Key? key}) : super(key: key);

  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  final List<LearningTile> tile1 = [
    LearningTile(title: '第1周', contents: 'test'),
    LearningTile(title: '標題1', contents: 'ISO65163'),
    LearningTile(title: '標題2', contents: 'I_SCO_'),
    LearningTile(title: '標題3', contents: 'test3'),
    LearningTile(title: '標題4', contents: 'I_SCO_5163'),
    LearningTile(title: '標題5', contents: 'ISO65163')
  ];
  final List<LearningTile> tile2 = [
    LearningTile(title: '第2周', contents: 'test'),
    LearningTile(title: '標題1', contents: 'I_SCO_5163'),
    LearningTile(title: '標題2', contents: 'ISO65163'),
    LearningTile(title: '標題3', contents: 'test3'),
    LearningTile(title: '標題4', contents: 'ISO65163'),
    LearningTile(title: '標題5', contents: 'test5')
  ];
  final List<LearningTile> tile3 = [
    LearningTile(title: '第3周', contents: 'test'),
    LearningTile(title: '標題1', contents: 'I_SCO_O65163'),
    LearningTile(title: '標題2', contents: 'I_SCO_65163'),
    LearningTile(title: '標題3', contents: 'ISO65163'),
    LearningTile(title: '標題4', contents: 'I_SCO_65163'),
    LearningTile(title: '標題5', contents: 'test5')
  ];
  late final List tiles = [
    LearningTiles(tiles: tile1),
    LearningTiles(tiles: tile2),
    LearningTiles(tiles: tile3)
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: tiles.length,
        itemBuilder: (BuildContext context, int index) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return Column(
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                    childrenPadding:
                        const EdgeInsets.fromLTRB(.0, .0, .0, 18.0),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      tiles[index].tiles[0].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // height: .1,
                      ),
                    ),
                    children: tiles[index].tiles.map((tile) {
                      bool contain = tile.contents.contains('I_SCO');
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ListTile(
                            leading: Icon(Icons.calculate),
                            title: Text(tile.title),
                            subtitle: contain
                                ? ElevatedButton(
                                    onPressed: () {}, child: Text('進入教材'))
                                : null),
                      );
                    }).toList()),
              ),
              Divider(
                height: .0,
                thickness: 1.5,
              ),
            ],
          );
        });
  }
}
