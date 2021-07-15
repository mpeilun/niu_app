import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/service/SemesterDate.dart';

const List<StaggeredTile> _tiles = <StaggeredTile>[
  StaggeredTile.count(2, 2),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(4, 1),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(4, 2),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 4),
  StaggeredTile.count(1, 3),
  StaggeredTile.count(1, 2),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 1),
  StaggeredTile.count(1, 1),
];

StaggeredTile? _getStaggeredTile(int i) {
  return i >= _tiles.length ? null : _tiles[i];
}

class TimeTable extends StatefulWidget {
  final String title = '課表';
  TimeTable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('example 02'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 5,
          itemCount: 200,
          itemBuilder: (BuildContext context, int index) => Container(
              color: Colors.green,
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text('$index'),
                ),
              )),
          staggeredTileBuilder: (int index) =>_getStaggeredTile(index),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
      ),
    );
  }
}
