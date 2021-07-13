import 'package:flutter/material.dart';
import 'package:niu_app/grades/custom_cards.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  @override
  Widget build(BuildContext context) => CustomGradeCard(
        key: PageStorageKey<String>('final'),
        grade: grades,
      );
}
