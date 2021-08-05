import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Calendar extends StatelessWidget {
  const Calendar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("課表"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Container(
              child: Center(
                child: const SpinKitSquareCircle(
                  color: Color.fromRGBO(0, 70, 161, 1),
                  size: 60,
                ),
              )),
        ),
      ),
    );
  }
}