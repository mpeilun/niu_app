import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

double rowWidth = 125; // 第一列寬
double rowHeight = 50; // 第一列高
double colWidth = 50; // 第一欄寬
double colHeight = 125; // 第一欄高
int rowNum = 7; // 第一列數量
int colNum = 14; // 第一欄數量

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _headController;
  late ScrollController _bodyController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('課表'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableHead(
            scrollController: _headController,
          ),
          Expanded(
            child: TableBody(
              scrollController: _bodyController,
            ),
          ),
        ],
      ),
    );
  }
}

class TableHead extends StatelessWidget {
  final ScrollController scrollController;

  TableHead({
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: rowHeight,
      child: Row(
        children: [
          MultiplicationTableCell(
            color: Colors.transparent,
            borderColor: Colors.transparent,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                controller: scrollController,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: List.generate(rowNum, (index) {
                  return MultiplicationTableCell(
                    color: Colors.yellow.withOpacity(0.3),
                    value: index + 1,
                    width: rowWidth,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TableBody extends StatefulWidget {
  final ScrollController scrollController;

  TableBody({
    required this.scrollController,
  });

  @override
  _TableBodyState createState() => _TableBodyState();
}

class _TableBodyState extends State<TableBody> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _firstColumnController = _controllers.addAndGet();
    _restColumnsController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: colWidth,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              controller: _firstColumnController,
              physics: ClampingScrollPhysics(),
              children: List.generate(colNum, (index) {
                return MultiplicationTableCell(
                  color: Colors.yellow.withOpacity(0.3),
                  value: index + 1,
                  height: colHeight,
                );
              }),
            ),
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              controller: widget.scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: rowNum * rowWidth,
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    controller: _restColumnsController,
                    physics: const ClampingScrollPhysics(),
                    children: List.generate(colNum, (y) {     // y 每一列
                      print(y);
                      return Row(
                        children: List.generate(rowNum, (x) { // x 每一欄
                          print(x);
                          return MultiplicationTableCell(
                            value: (x + 1) + (y * rowNum),
                            width: rowWidth,
                            height: colHeight,
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MultiplicationTableCell extends StatelessWidget {
  final int? value;
  final Color? color;
  final Color? borderColor;
  final double? width;
  final double? height;

  MultiplicationTableCell({
    this.value,
    this.color,
    this.borderColor = Colors.black12,
    this.width = 50,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: borderColor!,
          width: 1.0,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '${value ?? ''}',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
