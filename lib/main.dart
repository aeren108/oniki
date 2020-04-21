import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/pages/add_page.dart';
import 'package:oniki/pages/login_page.dart';
import 'package:oniki/pages/register_page.dart';

import 'package:oniki/pages/home_page.dart';
import 'package:oniki/pages/request_post_page.dart';
import 'package:oniki/pages/user_settings_page.dart';
import 'package:oniki/services/auth_service.dart';
import 'package:oniki/services/user_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthService _authService = AuthService.instance;
  FirebaseUser user = await _authService.currentUser;
  String initRoute;
  if (user == null) {
    initRoute = '/register';
  } else {
    print(user.uid);
    UserService.currentUser = await UserService.instance.findUser(user.uid);
    if (UserService.currentUser != null)
      initRoute = '/home';
    else
      initRoute = '/register';
  }

  initRoute = (UserService.currentUser == null) ? '/register' : '/home';
  runApp(MyApp(initRoute));
}

class MyApp extends StatelessWidget {
  String initRoute;
  MyApp(this.initRoute);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
          }
        )
      ),

      initialRoute: initRoute,
      routes: <String, WidgetBuilder>{
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/add': (context) => AddPage(null),
        '/user-settings': (context) => UserSettingsPage(),
        '/request-post': (context) => RequestPostPage(),
        '/empty': (context) => Container()
      },
    );
  }
}

