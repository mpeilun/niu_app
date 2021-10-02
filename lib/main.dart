import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/menu/menu_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:niu_app/provider/drawer_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => OnItemClick()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OKToast(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NIU app',
        theme: ThemeData(
          //brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
            color: Colors.blue[900],
            //backwardsCompatibility: false,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.blue[900]),
          ),
          dividerTheme: DividerThemeData(
            thickness: 1.5,
            indent: 10,
            endIndent: 10,
          ),
          primaryColor: Colors.blue[900],
          scaffoldBackgroundColor: Colors.grey[200],
          textTheme: GoogleFonts.notoSansTextTheme(textTheme).copyWith(
            headline1: GoogleFonts.oswald(textStyle: textTheme.headline1),
          ),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoWillPopScopePageTransionsBuilder(),
            },
          ),
        ),
        home: StartMenu(),
      ),
    );
  }
}
