import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oniki/pages/add_page.dart';
import 'package:oniki/pages/login_page.dart';
import 'package:oniki/pages/register_page.dart';

import 'package:oniki/pages/home_page.dart';
import 'package:oniki/services/auth_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthService _authService = AuthService.instance;
  FirebaseUser user = await _authService.currentUser;

  String initRoute = (user == null) ? '/register' : '/home';
  runApp(MyApp(initRoute));
}

class MyApp extends StatelessWidget {
  String initRoute;
  MyApp(this.initRoute);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),

      initialRoute: initRoute,
      routes: <String, WidgetBuilder>{
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/add': (context) => AddPage(),
        '/empty': (context) => Container()
      },

    );
  }

}

