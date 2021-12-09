import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/grades/grades.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/menu/icons/my_flutter_app_icons.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:provider/provider.dart';

class Quote {
  final String lesson;
  final String? score;
  final String? type;
  final String? teacher;
  final bool? warn;
  final bool? gradeWarn;
  final bool? attendanceWarn;
  final bool? presentWarn;

  Quote({
    required this.lesson,
    this.score,
    this.type,
    this.teacher,
    this.warn = false,
    this.gradeWarn = false,
    this.attendanceWarn = false,
    this.presentWarn = false,
  });
}

class CustomMidCard extends StatefulWidget {
  final List<Quote> grade;

  const CustomMidCard({Key? key, required this.grade}) : super(key: key);

  @override
  _CustomMidCardState createState() => _CustomMidCardState();
}

class _CustomMidCardState extends State<CustomMidCard> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      gradeScrollController.jumpTo(_scrollController.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.grade.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 8,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        bool isFail = false;
        if (widget.grade[index].score != '未上傳') {
          double score = double.parse('${widget.grade[index].score}');
          if (score < 60.0) {
            isFail = true;
          }
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.grade[index].lesson,
                    style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '分數：${widget.grade[index].score}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: themeChange.darkTheme ? isFail ? Colors.red : Colors.grey[400] : isFail ? Colors.red : Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${widget.grade[index].type}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: themeChange.darkTheme ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomFinalCard extends StatefulWidget {
  const CustomFinalCard(
      {Key? key, required this.rank, required this.avg, required this.grade})
      : super(key: key);

  final String rank;
  final String avg;
  final List<Quote> grade;

  @override
  _CustomFinalCardState createState() => _CustomFinalCardState();
}

class _CustomFinalCardState extends State<CustomFinalCard> {
  ScrollController _listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //widget.grade.insert(0, Quote(lesson: 'null'));
    _listScrollController.addListener(() {
      gradeScrollController.jumpTo(_listScrollController.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return ListView.separated(
      controller: _listScrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.grade.length + 1,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 8,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        if(index == 0){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    key: PageStorageKey('rank'),
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    title: Text(
                      "班級排名：${widget.rank}",
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 12.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "期末平均：${widget.avg}",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        }
        else{
          bool isFail = false;
          if (widget.grade[index-1].score != '未上傳') {
            double score = double.parse('${widget.grade[index-1].score}');
            if (score < 60.0) {
              isFail = true;
            }
          }
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            elevation: 1.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18.0, vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.grade[index-1].lesson,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '分數：${widget.grade[index-1].score}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: themeChange.darkTheme ? isFail ? Colors.red : Colors.grey[400] : isFail ? Colors.red : Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${widget.grade[index-1].type}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: themeChange.darkTheme ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class CustomWarnCard extends StatefulWidget {
  final List<Quote> grade;

  const CustomWarnCard({Key? key, required this.grade}) : super(key: key);

  @override
  _CustomWarnCardState createState() => _CustomWarnCardState();
}

class _CustomWarnCardState extends State<CustomWarnCard> {
  var isWarnList = const [];
  var isGradeList = const [];
  var isAttendanceList = const [];
  var isPresentList = const [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      gradeScrollController.jumpTo(_scrollController.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    isWarnList = widget.grade.map((g) => g.warn ?? false).toList();
    isGradeList = widget.grade.map((g) => g.gradeWarn ?? false).toList();
    isAttendanceList =
        widget.grade.map((g) => g.attendanceWarn ?? false).toList();
    isPresentList = widget.grade.map((g) => g.presentWarn ?? false).toList();

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.grade.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 30.0,
        thickness: 1.5,
        indent: 10,
        endIndent: 10,
      ),
      itemBuilder: (BuildContext context, int index) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 4,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.grade[index].lesson,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${widget.grade[index].teacher}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: themeChange.darkTheme ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CGWIcon(
                    isWarnList: isWarnList,
                    title: '期中警示',
                    icon: MyFlutterApp.exclamation_circle,
                    index: index,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  CGWIcon(
                    isWarnList: isGradeList,
                    title: '期中成績',
                    icon: MyFlutterApp.times_circle,
                    index: index,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  CGWIcon(
                    isWarnList: isAttendanceList,
                    title: '出席率',
                    icon: MyFlutterApp.times_circle,
                    index: index,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  CGWIcon(
                    isWarnList: isPresentList,
                    title: '報告/其他',
                    icon: MyFlutterApp.times_circle,
                    index: index,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
