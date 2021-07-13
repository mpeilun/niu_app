import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/menu/icons/my_flutter_app_icons.dart';

class Quote {
  final String lesson;
  final double score;
  final String? teacher;
  final bool? warn;
  final bool? gradeWarn;
  final bool? attendanceWarn;
  final bool? presentWarn;

  Quote({
    required this.lesson,
    required this.score,
    String? teacher,
    bool? warn,
    bool? gradeWarn,
    bool? attendanceWarn,
    bool? presentWarn,
  })  : this.teacher = teacher,
        this.warn = warn ?? false,
        this.gradeWarn = gradeWarn ?? false,
        this.attendanceWarn = attendanceWarn ?? false,
        this.presentWarn =  presentWarn ?? false;
}

final List<Quote> grades = [
  Quote(lesson: '課程一', score: 80.0, teacher: 'CC', warn: false),
  Quote(lesson: '課程二', score: 85.0),
  Quote(
    lesson: '課程3',
    score: 75.0,
    teacher: 'BB',
    warn: true,
    gradeWarn: true,
  ),
  Quote(lesson: '課程4', score: 65.0),
  Quote(lesson: '課程5', score: 95.0),
  Quote(
    lesson: '課程5',
    score: 95.0,
    teacher: 'RR',
    warn: true,
    gradeWarn: true,
    presentWarn: true,
  ),
  Quote(lesson: '課程5', score: 95.0),
  Quote(lesson: '課程5', score: 95.0, teacher: 'VVV'),
  Quote(lesson: '課程5', score: 95.0),
  Quote(lesson: '課程5', score: 95.0, teacher: 'AA'),
];

class CustomGradeCard extends StatelessWidget {
  final List<Quote> grade;

  const CustomGradeCard({Key? key, required this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: grade.length,
      itemBuilder: (BuildContext context, int index) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 1.5,
        margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 8.0),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ListTile(
            title: Text(
              grade[index].lesson,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              '分數：${grade[index].score}',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomWarnCard extends StatefulWidget {
  final List<Quote> grade;

  const CustomWarnCard({
    Key? key,
    required this.grade,
  }) : super(key: key);

  @override
  _CustomWarnCardState createState() => _CustomWarnCardState();
}

class _CustomWarnCardState extends State<CustomWarnCard> {
  var isWarnList = [];
  var isGradeList = [];
  var isAttendanceList = [];
  var isPresentList = [];

  @override
  Widget build(BuildContext context) {
    isWarnList = widget.grade.map((g) => g.warn ?? false).toList();
    isGradeList = widget.grade.map((g) => g.gradeWarn ?? false).toList();
    isAttendanceList = widget.grade.map((g) => g.attendanceWarn ?? false).toList();
    isPresentList = widget.grade.map((g) => g.presentWarn ?? false).toList();

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: widget.grade.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1.5,
        indent: 12,
        endIndent: 10,
      ),
      itemBuilder: (BuildContext context, int index) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 2.0, 18.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.grade[index].lesson,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${widget.grade[index].teacher}',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 1.5,
            margin: const EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 12.0),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CGWIcon(
                    isWarnList: isWarnList,
                    title: '期中警示',
                    icon: MyFlutterApp.exclamation,
                    index: index,
                  ),
                  CGWIcon(
                    isWarnList: isGradeList,
                    title: '期中成績',
                    icon: Icons.clear_rounded,
                    index: index,
                  ),
                  CGWIcon(
                    isWarnList: isAttendanceList,
                    title: '出席率',
                    icon: Icons.clear_rounded,
                    index: index,
                  ),
                  CGWIcon(
                    isWarnList: isPresentList,
                    title: '報告/其他',
                    icon: Icons.clear_rounded,
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


