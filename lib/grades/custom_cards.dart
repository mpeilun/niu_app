import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:niu_app/menu/icons/my_flutter_app_icons.dart';

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
    String? score,
    String? type,
    String? teacher,
    bool? warn,
    bool? gradeWarn,
    bool? attendanceWarn,
    bool? presentWarn,
  })  : this.score = score,
        this.type = type,
        this.teacher = teacher,
        this.warn = warn ?? false,
        this.gradeWarn = gradeWarn ?? false,
        this.attendanceWarn = attendanceWarn ?? false,
        this.presentWarn = presentWarn ?? false;
}

class CustomGradeCard extends StatelessWidget {
  final List<Quote> grade;

  const CustomGradeCard({Key? key, required this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: key,
      padding: const EdgeInsets.all(8.0),
      physics: BouncingScrollPhysics(),
      itemCount: grade.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 8,
        );
      },
      itemBuilder: (BuildContext context, int index) => Container(
        height: 80.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          elevation: 1.5,
          //margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 8.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    grade[index].lesson,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '分數：${grade[index].score}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${grade[index].type}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
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
    isAttendanceList =
        widget.grade.map((g) => g.attendanceWarn ?? false).toList();
    isPresentList = widget.grade.map((g) => g.presentWarn ?? false).toList();

    return ListView.separated(
      key: widget.key,
      padding: const EdgeInsets.all(8.0),
      physics: BouncingScrollPhysics(),
      itemCount: widget.grade.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 30.0,
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
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
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
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 16.0,
            child: Card(
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
                      icon: MyFlutterApp.exclamation,
                      index: index,
                    ),
                    SizedBox(width: 10.0,),
                    CGWIcon(
                      isWarnList: isGradeList,
                      title: '期中成績',
                      icon: MyFlutterApp.times_circle,
                      index: index,
                    ),
                    SizedBox(width: 10.0,),
                    CGWIcon(
                      isWarnList: isAttendanceList,
                      title: '出席率',
                      icon: MyFlutterApp.times_circle,
                      index: index,
                    ),
                    SizedBox(width: 10.0,),
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
          ),
        ],
      ),
    );
  }
}
