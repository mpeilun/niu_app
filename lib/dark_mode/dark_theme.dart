import 'dart:ui';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      primaryColor: isDarkTheme ? Color(0xff212121) : Colors.blue[900],
      scaffoldBackgroundColor:
          isDarkTheme ? Color(0xff303030) : Colors.grey[200],
      indicatorColor: isDarkTheme ? Colors.grey[800] : null,
      toggleableActiveColor: isDarkTheme ? Colors.grey[600] : null,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isDarkTheme ? Color(0xff212121) : Colors.blue[900],
        foregroundColor: Colors.grey[200],
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: isDarkTheme ? Colors.grey[600] : Colors.blue[800],
        cursorColor: isDarkTheme ? Color(0xff212121) : Colors.blue,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: isDarkTheme ? Colors.grey[200] : null,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(
              width: 2.0, color: isDarkTheme ? Color(0xff212121) : Colors.blue),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color?>(
              isDarkTheme ? Color(0xff212121) : Colors.blue[700]),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
        ),
      ),
      iconTheme: IconThemeData(
        color: isDarkTheme ? Color(0xe0ffffff) : Colors.white,
      ),
      // backgroundColor: isDarkTheme ? Color(0xff121212) : Colors.grey[200],
      // cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      // hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      // highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      // hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      // focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      // disabledColor: Colors.grey,
      // canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      // buttonTheme: Theme.of(context).buttonTheme.copyWith(
      //     colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      // textSelectionTheme: TextSelectionThemeData(
      //     selectionColor: isDarkTheme ? Colors.white : Colors.black),
      appBarTheme: AppBarTheme(
        color: isDarkTheme ? Color(0xff212121) : Colors.blue[900],
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness:
                isDarkTheme ? Brightness.dark : Brightness.light,
            statusBarColor: isDarkTheme ? Color(0xff000000) : Colors.blue[900]),
      ),
      // textTheme: GoogleFonts.notoSansTextTheme(
      //   Theme.of(context).textTheme,
      // ),

      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoWillPopScopePageTransionsBuilder(),
        },
      ),
    );
  }
}
