import 'package:flutter/material.dart';
import 'package:niu_app/e_school/advanced_tiles.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({
    Key? key,
  }) : super(key: key);

  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ExpansionPanelList.radio(
          animationDuration: Duration(milliseconds: 750),
          children: advancedTile.map((tile) {
            int submitCount = 0;
            int workCount = tile.tiles.length;
            tile.tiles.map((tile) {
              if (tile.isSubmit == true) {
                return submitCount++;
              }
            }).toList();
            bool isFinish = false;
            if (submitCount == workCount) {
              isFinish = true;
            }
            return ExpansionPanelRadio(
                value: tile.title,
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) =>
                    ListTile(
                      leading: tile.icon != null ? Icon(tile.icon) : null,
                      title: Text(
                        tile.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: LinearPercentIndicator(
                          width: 200.0,
                          animation: true,
                          animationDuration: 1000,
                          lineHeight: 20.0,
                          leading: Text(
                            "繳交進度",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: Text(
                            "$submitCount/$workCount",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          percent: submitCount / tile.tiles.length,
                          center: Text(
                              "${(submitCount / workCount * 100).toStringAsFixed(2)}%"),
                          linearStrokeCap: LinearStrokeCap.butt,
                          progressColor:
                              isFinish ? Colors.greenAccent : Colors.amber,
                        ),
                      ),
                    ),
                body: Column(
                  children: tile.tiles
                      .map((tile) => Padding(
                            padding: const EdgeInsets.fromLTRB(
                                24.0, 0.0, 24.0, 16.0),
                            child: Container(
                              height: 30.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    tile.title,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  tile.isSubmit
                                      ? Container(
                                          width: 60.0,
                                          child: Center(child: Text('已繳交')),
                                        )
                                      : Container(
                                          width: 60.0,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            child: Text('繳交'),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ));
          }).toList(),
        ),
      ),
    );
  }
}
