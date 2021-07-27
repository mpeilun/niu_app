import 'package:flutter/material.dart';
import 'package:niu_app/grades/custom_cards.dart';
/*
class FinalPage extends StatefulWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {


  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        ListTile(title:Text("學期平均：$avg \t\t\t 班級排名：$rank")),
        Expanded(
          child: CustomGradeCard(
            key: PageStorageKey<String>('final'),
            grade: grades,
          ),
        ),
      ],
    );
  }
}*/


class FinalPage extends StatelessWidget {
  final double avg;
  final int rank;

  const FinalPage({Key? key, required this.avg, required this.rank}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        ListTile(title:Text("學期平均：$avg \t\t\t 班級排名：$rank", style: TextStyle(fontSize: 22.0),)),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 14.0),
          height: 1.0,
          color: Colors.black,
        ),
        Expanded(
          child: CustomGradeCard(
            key: PageStorageKey<String>('final'),
            grade: grades,
          ),
        ),
      ],
    );
  }
}
