import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:niu_app/timetable/multiplication_table_cell.dart';
import 'package:niu_app/timetable/timetable_class.dart';
import 'package:provider/provider.dart';

import '../provider/dark_mode_provider.dart';

double rowWidth = 80; // 第一列寬
double rowHeight = 40; // 第一列高
double colWidth = 40; // 第一欄寬
double colHeight = 110; // 第一欄高
int rowNum = 7; // 第一列數量
int colNum = 14; // 第一欄數量

class TimetableBody extends StatefulWidget {
  TimetableBody({
    Key? key,
    required this.timetableData,
  }) : super(key: key);
  final List<List<TimetableClass>> timetableData;

  @override
  _TimetableBodyState createState() => _TimetableBodyState();
}

class _TimetableBodyState extends State<TimetableBody> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _headController;
  late ScrollController _bodyController;

  int classNum = 14;
  int weekDayNum = 7;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();
    // _bodyController.addListener(() {print(_bodyController.offset); });
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Column(
        children: [
          TableHead(
            scrollController: _headController,
          ),
          Expanded(
            child: TableBody(
              scrollController: _bodyController,
              timetableData: widget.timetableData,
            ),
          ),
        ],
      ),
    );
  }
}

class TableHead extends StatelessWidget {
  final ScrollController scrollController;
  final List<String> weekDayName = <String>[
    "星期一",
    "星期二",
    "星期三",
    "星期四",
    "星期五",
    "星期六",
    "星期日"
  ];

  TableHead({
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SizedBox(
      height: rowHeight,
      child: Row(
        children: [
          MultiplicationTableCell(
            color: themeChange.darkTheme ? Color.fromARGB(255, 76, 76, 76) : Colors.grey.shade300,
            verBorderColor: themeChange.darkTheme ? Color.fromARGB(255, 76, 76, 76) : Colors.grey.shade300,
            horBorderColor: themeChange.darkTheme ? Color.fromARGB(255, 76, 76, 76) : Colors.grey.shade300,
            value: 'Time',
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
                    color: themeChange.darkTheme ? Color.fromARGB(255, 76, 76, 76) : Colors.grey.shade300,
                    verBorderColor: themeChange.darkTheme ? Color.fromARGB(255, 76, 76, 76) : Colors.grey.shade300,
                    horBorderColor: themeChange.darkTheme ? Color.fromARGB(255, 76, 76, 76) : Colors.grey.shade300,
                    value: weekDayName[index],
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
  final List<List<TimetableClass>> timetableData;

  TableBody({
    required this.scrollController,
    required this.timetableData,
  });

  @override
  _TableBodyState createState() => _TableBodyState();
}

class _TableBodyState extends State<TableBody> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;
  List<Color> colors = <Color>[
    Color(0xff3DA5D9).withOpacity(0.75),
    Color(0xff5dd5e0).withOpacity(0.75),
    Color(0xff73BFB8).withOpacity(0.75),
    Color(0xffF4B9B2).withOpacity(0.75),
    Color(0xffEF7C8E).withOpacity(0.75),
    Color(0xffB9C35D).withOpacity(0.75),
    Color(0xffFEC601).withOpacity(0.75),
    Color(0xffEF8812).withOpacity(0.75),
    Color(0xff2A9D8F).withOpacity(0.75),
    Color(0xff8AB17D).withOpacity(0.75),
    Color(0xffBABB74).withOpacity(0.75),
    Color(0xffE9C46A).withOpacity(0.75),
    Color(0xffF4A261).withOpacity(0.75),
    Color(0xffE76F51).withOpacity(0.75),
  ];
  List<Color> colorsD = <Color>[
    Color(0xff3DA5D9).withOpacity(.9),
    Color(0xff5dd5e0).withOpacity(.9),
    Color(0xff73BFB8).withOpacity(.9),
    Color(0xffF4B9B2).withOpacity(.9),
    Color(0xffEF7C8E).withOpacity(.9),
    Color(0xffB9C35D).withOpacity(.9),
    Color(0xffFEC601).withOpacity(.9),
    Color(0xffff9d36).withOpacity(.9),
    Color(0xff2A9D8F).withOpacity(.9),
    Color(0xff8AB17D).withOpacity(.9),
    Color(0xffBABB74).withOpacity(.9),
    Color(0xffE9C46A).withOpacity(.9),
    Color(0xffF4A261).withOpacity(.9),
    Color(0xffE76F51).withOpacity(.9),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _firstColumnController = _controllers.addAndGet();
    _restColumnsController = _controllers.addAndGet();
    // _restColumnsController.addListener(() {print(_restColumnsController.offset); });
  }

  @override
  void dispose() {
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Set<String> lesson = {};
    widget.timetableData.forEach((element) {element.forEach((element) {lesson.add(element.lesson);});});
    // teacher.forEach((element) {print(element);});
    return Row(
      children: [
        TimeHeader(firstColumnController: _firstColumnController),
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
                    children: List.generate(colNum, (y) {
                      // y 每一列
                      return Row(
                        children: List.generate(rowNum, (x) {
                          Color color = Colors.transparent;
                          for (int i = 0; i<lesson.length; i++){
                            if(lesson.elementAt(i) == widget.timetableData[y][x].lesson){
                              color = themeChange.darkTheme ? colorsD[i] : colors[i];
                            }
                          }
                          bool isRoomEmpty =
                              (widget.timetableData[y][x].room == '');
                          return MultiplicationTableCell(
                            value: isRoomEmpty
                                ? '${widget.timetableData[y][x].teacher}\n${widget.timetableData[y][x].lesson}'
                                : '${widget.timetableData[y][x].teacher}\n${widget.timetableData[y][x].lesson}\n${widget.timetableData[y][x].room}',
                            width: rowWidth,
                            height: colHeight,
                            color: widget.timetableData[y][x].isEmpty
                                ? Colors.transparent
                                : color,
                            marginHor: 3,
                            marginTop: 3,
                            marginBottom: 3,
                            topRadius: 6,
                            bottomRadius: 6,
                            verBorderColor: themeChange.darkTheme ? Color.fromARGB(255, 76, 76, 76) : Colors.black12,
                            horBorderColor: themeChange.darkTheme ? Color.fromARGB(255, 76, 76, 76) : Colors.black12,
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

class TimeHeader extends StatefulWidget {
  TimeHeader({
    Key? key,
    required this.firstColumnController,
  }) : super(key: key);
  final ScrollController firstColumnController;

  @override
  State<TimeHeader> createState() => _TimeHeaderState();
}

class _TimeHeaderState extends State<TimeHeader> {
  final List<String> timeName = const [
    "特\n早\n課",
    "第\n一\n節",
    "第\n二\n節",
    "第\n三\n節",
    "第\n四\n節",
    "第\n五\n節",
    "第\n六\n節",
    "第\n七\n節",
    "第\n八\n節",
    "第\n九\n節",
    "第\nA\n節",
    "第\nB\n節",
    "第\nC\n節",
    "第\nD\n節",
  ];

  final List<String> timeRange = const [
    "07:10\n08:00", //0
    "08:10\n09:00", //1
    "09:10\n10:00", //2
    "10:10\n11:00", //3
    "11:10\n12:00", //4
    "13:10\n14:00", //5
    "14:10\n15:00", //6
    "15:10\n16:00", //7
    "16:10\n17:00", //8
    "17:10\n18:00", //9
    "18:20\n19:10", //a
    "19:15\n20:05", //b
    "20:10\n21:00", //c
    "21:05\n21:55", //d
  ];

  bool time = false;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SizedBox(
      width: colWidth,
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          controller: widget.firstColumnController,
          physics: ClampingScrollPhysics(),
          children: List.generate(colNum, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  time = !time;
                });
              },
              child: MultiplicationTableCell(
                value: time ? '${timeRange[index]}' : '${timeName[index]}',
                height: colHeight,
                verBorderColor: themeChange.darkTheme ? Color.fromARGB(255, 76, 76, 76) : Colors.black12,
                horBorderColor: themeChange.darkTheme ? Color.fromARGB(255, 76, 76, 76) : Colors.black12,
              ),
            );
          }),
        ),
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

