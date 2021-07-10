import 'package:flutter/material.dart';

class WarmPage extends StatefulWidget {
  const WarmPage({Key? key}) : super(key: key);

  @override
  _WarmPageState createState() => _WarmPageState();
}

class _WarmPageState extends State<WarmPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("期中預警頁"),
    );
  }
}
