import 'package:flutter/material.dart';
import 'package:niu_app/external_lib/flutter_login/flutter_login.dart';
import 'package:niu_app/menu/menu_page.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'NIU',
      logo: 'assets/niu_logo.png',
      onLogin: (_) {
        print('login');
      },
      hideForgotPasswordButton: true,
      hideSignUpButton: true,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            return StartMenu(
              title: '功能列表',
            );
          },
        ));
      },
      messages: LoginMessages(
        userHint: 'Number',
        passwordHint: 'Password',
        loginButton: 'LOG IN',
      ),
    );
  }
}
