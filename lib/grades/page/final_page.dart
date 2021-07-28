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
        ListTile(title:Text("班級排名：$rank\n學期平均：$avg", style: TextStyle(fontSize: 22.0),)),
        Divider(),
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
