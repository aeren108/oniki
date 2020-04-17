import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/pages/auth_form.dart';
import 'package:oniki/pages/home_page.dart';
import 'package:oniki/services/auth_service.dart';
import 'package:oniki/services/user_service.dart';

class RegisterPage extends AuthForm {
  static final _stateKey = GlobalKey<AuthFormState>();
  final AuthService _authService = AuthService.instance;

  String email, name, password;
  String confirmText = "KAYIT OL";

  IconData visibility = Icons.visibility;
  bool isVisible = false;

  RegisterPage() : super(_stateKey);

  @override
  List<Widget> buildForm(BuildContext context) {
    return <Widget>[
      TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_circle),
            labelText: "İsim"
        ),

        validator: (name) {
          if (name.isEmpty)
            return "İsim boş olamaz";
          return null;
        },

        onSaved: (name) { this.name = name; },
      ),

      SizedBox(height: 10),

      TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.alternate_email),
              labelText: "E-Posta"
          ),

          validator: (email) {
            bool isValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

            if (!isValid)
              return "E-Posta geçerli değil";
            return null;
          },

          onSaved: (email) { this.email = email; }
      ),

      SizedBox(height: 10),

      TextFormField(
        obscureText: !isVisible,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
            labelText: "Şifre",
            suffixIcon: GestureDetector(
              child: Icon(visibility),
              onTap: () {
                _stateKey.currentState.setState(() {
                  isVisible = !isVisible;
                  visibility = isVisible ? Icons.visibility_off : Icons.visibility;
                });
              },
            )
        ),

        validator: (pswd) {
          if (pswd.length < 6)
            return "Şifre en az 6 karakter uzunluğunda olmalı";
          return null;
        },

        onSaved: (password) { this.password = password; } ,
      ),
    ];
  }

  @override
  List<Widget> buildFooter(BuildContext context) {
    return <Widget>[
      Text("Zaten hesabın var mı ?", style: TextStyle(color: Colors.black87, fontSize: 15)),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: InkWell(
            child: Text("Giriş yap", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            }
        ),
      )
    ];
  }

  @override
  void confirmAction(BuildContext context) {
    _stateKey.currentState.setState(() => isLoading = true);

    _authService.registerWithEmail(email, password).then((user) {
      UserService.instance.createUser(name, user.uid);
      User u = User.newUser(name, user.uid);
      UserService.currentUser = u;

      Navigator.pushReplacementNamed(context, '/home');

      _authService.currentUser.then((user) {
        UserUpdateInfo info = UserUpdateInfo();
        info.displayName = name;
        user.updateProfile(info).then((arg) {
          user.reload();
        });
      });
    }).catchError((error) {
      _stateKey.currentState.setState(() => isLoading = false);
      String info;

      switch (error.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          info = 'E-Posta zaten kullanımda';
          break;
        case 'ERROR_INVALID_EMAIL':
          info = 'Geçersiz E-Posta';
          break;
        case 'ERROR_WEAK_PASSWORD':
          info = 'Şifre zayıf';
          break;
        default:
          info = error.code;
          break;
      }

      scaffold.currentState.showSnackBar(SnackBar(content: Text(info, style: TextStyle(fontSize: 16)), backgroundColor: alertColor));
    });
  }
}