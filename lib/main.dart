import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:niu_app/menu/menu_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:niu_app/provider/drawer_provider.dart';
import 'package:niu_app/provider/info_provider.dart';
import 'package:niu_app/provider/notification_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/timetable_button_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var initializationSettingAndroid = AndroidInitializationSettings("niu_logo");
  var initializationSettingIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {},
  );
  var initializationSettings = InitializationSettings(
    android: initializationSettingAndroid,
    iOS: initializationSettingIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) print("Notification Payload: " + payload);
  });

  FirebaseMessaging  messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  messaging.getToken().then((value){
    print("Token : $value");
    FirebaseFirestore.instance
        .collection("Token")
        .add({'string' : value.toString()});
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print("message recieved");
    print(event.notification!.body);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DrawerProvider()),
    ChangeNotifierProvider(create: (_) => TimeCardClickProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ChangeNotifierProvider(create: (_) => InfoProvider()),
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
          // dividerTheme: DividerThemeData(
          //   thickness: 1.5,
          //   indent: 10,
          //   endIndent: 10,
          // ),
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
