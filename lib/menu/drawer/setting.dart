import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "ABC字體",
          style: TextStyle(
              fontSize: 54.0,
            ),
        ),
        Text(
          "ABC字體",
          style: GoogleFonts.notoSerif(
            textStyle: TextStyle(
              fontSize: 54.0,
            ),
          ),
        ),
        Text(
          "ABC字體",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 54.0,
            ),
          ),
        ),
      ]),
    );
  }
}
