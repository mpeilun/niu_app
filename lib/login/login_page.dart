import 'dart:async';

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:niu_app/components/login_loading.dart';
import 'package:niu_app/login/studio_info.dart';
import 'package:niu_app/menu/notification/notification_webview.dart';
import 'package:niu_app/provider/drawer_provider.dart';
import 'package:niu_app/provider/info_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_method.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String id;
  late String pwd;
  Future<String> _authUser(LoginData data) async {
    await Login.origin().cleanAllData();
    context.read<DrawerProvider>().closeDrawer();
    context.read<DrawerProvider>().onclick(0);
    id = data.name;
    pwd = data.password;
    return (await Login(id, pwd).niuLogin().timeout(Duration(seconds: 60),
            onTimeout: () {
      return '學校系統異常';
    }))
        .replaceAll('登入成功', '');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
        child: Container(
            child: FlutterLogin(
          title: '宜大學生 APP',
          logo: 'assets/niu_logo.png',
          onLogin: _authUser,
          hideForgotPasswordButton: true,
          hideSignUpButton: true,
          onSubmitAnimationCompleted: () async {
            String name = await getStudioName();
            await setStudioData(id, pwd, name);
            context.read<InfoProvider>().setName(name);
            loadDataFormPrefs(context);
            runNotificationWebViewWebView(context, null);
            Navigator.pop(context);
          },
          theme: LoginTheme(
            logoWidth: 0.45,
            titleStyle: TextStyle(fontSize: 30),
            primaryColor: Theme.of(context).primaryColor,
            //cardTheme: CardTheme(color: Colors.grey[200]),
          ),
          messages: LoginMessages(
            userHint: '學號',
            passwordHint: '密碼',
            loginButton: '登入',
            flushbarTitleError: '錯誤',
          ),
        )),
        onWillPop: () async {
          return false;
        },
        shouldAddCallbacks: true);
  }
}
