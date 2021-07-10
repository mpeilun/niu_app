import 'package:flutter/material.dart';
import 'package:niu_app/grades/quotes.dart';


class FinalPage extends StatefulWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  final List<Quote> grades = [
    Quote(lesson: '課程一', score: 80.0),
    Quote(lesson: '課程二', score: 85.0),
    Quote(lesson: '課程3', score: 75.0),
    Quote(lesson: '課程4', score: 65.0),
    Quote(lesson: '課程5', score: 95.0),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: grades.length,
      itemBuilder: (BuildContext context, int index) => ListTile(
        title: Text(
          grades[index].lesson,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '分數：${grades[index].score}',
          style: TextStyle(fontSize: 18.0,),
        ),
      ),
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1.0,
        color: Colors.black,
      ),
    );
  }
}
