import 'package:flutter/material.dart';
import 'package:niu_app/grades/custom_cards.dart';

class MidPage extends StatefulWidget {
  const MidPage({Key? key}) : super(key: key);

  @override
  _MidPageState createState() => _MidPageState();
}

class _MidPageState extends State<MidPage> {
  @override
  Widget build(BuildContext context) => CustomGradeCard(
        key: PageStorageKey<String>('mid'),
        grade: grades,
      );
}
