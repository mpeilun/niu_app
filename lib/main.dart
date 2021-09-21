import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/menu/menu_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:niu_app/provider/drawer_provider.dart';
import 'package:niu_app/menu/loading.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  ChangeNotifierProvider(create: (_) => OnItemClick());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'SecondaryApp'
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("FireBase ERROR");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
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
            ),
            home: StartMenu(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        //報錯但不影響執行
        return Loading();
      },
    );


  }
}
