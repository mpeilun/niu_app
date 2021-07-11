import 'package:flutter/material.dart';

class Quote {
  final String lesson;
  final double score;
  final String? teacher;

  Quote({required this.lesson, required this.score, String? teacher ,}) : this.teacher = teacher;
}

final List<Quote> grades = [
  Quote(lesson: '課程一', score: 80.0, teacher: 'CCCC'),
  Quote(lesson: '課程二', score: 85.0),
  Quote(lesson: '課程3', score: 75.0),
  Quote(lesson: '課程4', score: 65.0),
  Quote(lesson: '課程5', score: 95.0),
  Quote(lesson: '課程5', score: 95.0),
  Quote(lesson: '課程5', score: 95.0),
  Quote(lesson: '課程5', score: 95.0),
  Quote(lesson: '課程5', score: 95.0),
  Quote(lesson: '課程5', score: 95.0),
];

final List<Quote> grades2 = [
  Quote(lesson: '課程99', score: 80.0, teacher: 'star',),
  Quote(lesson: '課程88', score: 85.0, teacher: 'AA',),
  Quote(lesson: '課程77', score: 75.0, teacher: 'rock',),
  Quote(lesson: '課程66', score: 65.0,),
  Quote(lesson: '課程55', score: 95.0, teacher: 'BB',),
  Quote(lesson: '課程44', score: 95.0, teacher: 'CC',),
  Quote(lesson: '課程33', score: 95.0,),
  Quote(lesson: '課程22', score: 95.0, teacher: 'gas',),
  Quote(lesson: '課程11', score: 95.0,),
  Quote(lesson: '課程00', score: 95.0,),
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
        elevation: 1.5,
        margin: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 4.0),
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

class CustomWarnCard extends StatelessWidget {
  final List<Quote> grade;
  const CustomWarnCard({
    Key? key,
    required this.grade,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: grade.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1.5,
        indent: 12,
        endIndent: 10,
      ),
      itemBuilder: (BuildContext context, int index) => Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 4.0, 14.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    grade[index].lesson,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${grade[index].teacher}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 1.5,
              margin: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 8.0),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                            '')
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
