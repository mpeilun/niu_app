import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:provider/provider.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return SafeArea(
      child: Container(
        color: themeChange.darkTheme ? Color(0xff212121) : Colors.blue[900],
          child: Center(
        child: const SpinKitSquareCircle(
          color: Colors.white,
          size: 60,
        ),
      )),
    );
  }
}
