import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:niu_app/e_school/advanced_tiles.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({
    Key? key,
  }) : super(key: key);

  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage>
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
    return CustomWorkCard(tile: advancedTile);
  }
}





class CustomWorkCard extends StatefulWidget {
  const CustomWorkCard({
    Key? key,
    required this.tile,
  }) : super(key: key);

  final List<AdvancedTile> tile;

  @override
  _CustomWorkCardState createState() => _CustomWorkCardState();
}

class _CustomWorkCardState extends State<CustomWorkCard> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      //controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.tile.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 8,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        double workCount = double.parse('${widget.tile[index].workCount}');
        double submitCount = double.parse('${widget.tile[index].submitCount}');
        bool isFinish = false;
        bool isZero = false;
        if (submitCount == workCount) {
          isFinish = true;
        }
        if (workCount == 0) {
          isZero = true;
        }
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          elevation: 1.5,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${widget.tile[index].title}',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    Tooltip(
                      showDuration: Duration(milliseconds: 500),
                      message: '前往作業繳交區',
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                            minimumSize: Size(0.0, 0.0),
                          ),
                          child: Text("Go!",
                              style:
                              TextStyle(fontSize: 14, color: Colors.white)),
                          onPressed: () => null),
                    ),
                  ],
                ),
                LinearPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  lineHeight: 20.0,
                  leading: Text(
                    "繳交進度",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Container(
                    width: 48.0,
                    child: Text(
                      "${submitCount.toStringAsFixed(0)}/${workCount.toStringAsFixed(0)}",
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  percent: isZero ? 1 : submitCount / workCount,
                  center: Text(
                      isZero ? "沒有作業" : "${(submitCount / workCount * 100).toStringAsFixed(2)}%",
                    textAlign: TextAlign.center,

                  ),
                  linearStrokeCap: LinearStrokeCap.butt,
                  progressColor:
                  isFinish ? Colors.greenAccent : Colors.amber,
                ),
                SizedBox(height: 10.0,)
              ],
            ),
          ),
        );
      },
    );
  }
}
// ListView.separated(
// //controller: _scrollController,
// padding: const EdgeInsets.all(8.0),
// itemCount: advancedTile.length,
// key: PageStorageKey<String>('Work'),
// //cacheExtent: 20.0,
// separatorBuilder: (BuildContext context, int index) {
// return SizedBox(
// height: 8,
// );
// },
// //physics: BouncingScrollPhysics(),
// itemBuilder: (BuildContext context, int index) {
// double workCount = double.parse('${advancedTile[index].workCount}');
// double submitCount = double.parse('${advancedTile[index].submitCount}');
// bool isFinish = false;
// if (submitCount == workCount) {
// isFinish = true;
// }
// return Card(
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(18.0),
// ),
// elevation: 1.5,
// child: Padding(
// padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
// child: Row(
// children: [
// ListTile(
// title: Text(
// 'tile.title',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// FittedBox(
// fit: BoxFit.scaleDown,
// child: LinearPercentIndicator(
// width: 200.0,
// animation: true,
// animationDuration: 1000,
// lineHeight: 20.0,
// leading: Text(
// "繳交進度",
// style: TextStyle(color: Colors.grey[600]),
// ),
// trailing: Text(
// //"$submitCount/$workCount",
// '123',
// style: TextStyle(color: Colors.grey[600]),
// ),
// percent: submitCount / workCount,
// center: Text(
// "${(submitCount / workCount * 100).toStringAsFixed(2)}%"),
// linearStrokeCap: LinearStrokeCap.butt,
// progressColor: isFinish ? Colors.greenAccent : Colors.amber,
// ),
// ),
// ],
// ),
// ),
// );
// },
// );
