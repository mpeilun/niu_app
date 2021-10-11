import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Container(
            child: Center(
          child: const SpinKitSquareCircle(
            color: Colors.white,
            size: 60,
          ),
        )),
      ),
    );
  }
}
