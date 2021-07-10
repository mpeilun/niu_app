import 'package:flutter/material.dart';
import 'package:niu_app/grades/custom_cards.dart';

class WarmPage extends StatefulWidget {
  const WarmPage({Key? key}) : super(key: key);

  @override
  _WarmPageState createState() => _WarmPageState();
}

class _WarmPageState extends State<WarmPage> {
  @override
  Widget build(BuildContext context) => CustomWarnCard(
    key: PageStorageKey<String>('warm'),
    grade: grades,
  );
}
