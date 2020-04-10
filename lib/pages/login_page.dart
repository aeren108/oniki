import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oniki/pages/auth_form.dart';
import 'package:oniki/services/auth_service.dart';
import 'package:oniki/services/user_service.dart';

class LoginPage extends AuthForm {
  static final _stateKey = GlobalKey<AuthFormState>();
  final _authService = AuthService.instance;

  String email, password;
  String confirmText = "GİRİŞ YAP";

  IconData visibility = Icons.visibility;
  bool isVisible = false;

  LoginPage() : super(_stateKey);

  @override
  List<Widget> buildForm(BuildContext context) {
    return <Widget>[
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
            suffixIcon: GestureDetector(
              child: Icon(visibility),
              onTap: () {
                _stateKey.currentState.setState(() {
                  isVisible = !isVisible;
                  visibility = isVisible ? Icons.visibility_off : Icons.visibility;
                });
              },
            ),
            labelText: "Şifre"
        ),

        validator: (pswd) {
          if (pswd.length < 6)
            return "Şifre uzunluğu en az 6 karakter olmalı";
          return null;
        },
        onSaved: (password) { this.password = password; } ,
      )
    ];
  }

  @override
  List<Widget> buildFooter(BuildContext context) {
    return <Widget>[
      Text("Hesabın yok mu ?", style: TextStyle(color: Colors.black87, fontSize: 15)),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: InkWell(
            child: Text("Kayıt ol", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/register');
            }
        ),
      )
    ];
  }

  @override
  void confirmAction(BuildContext context) {
    _stateKey.currentState.setState(() => isLoading = true);

    _authService.signInWithEmail(email, password).then((user) {
        UserService.instance.findUser(user.uid).then((usr) {
          UserService.currentUser = usr;

          Navigator.pushReplacementNamed(context, '/home');
        });
    }).catchError((error) {
      _stateKey.currentState.setState(() => isLoading = false);
      print("INFOOOO :: $error");
      String info;

      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          info = 'Geçersiz E-Posta';
          break;
        case 'ERROR_WRONG_PASSWORD':
          info = 'Yanlış şifre';
          break;
        case 'ERROR_USER_NOT_FOUND':
          info = 'Bu E-Posta ile kayıtlı kullanıcı bulunamadı';
          break;
        case 'ERROR_USER_DISABLED':
          info = 'Bu kullanıcı engellendi';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          info = 'Bir şeyler ters gitti, birazdan tekrar deneyin';
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          info = 'E-Posta ile giriş kullanımda değil';
          break;
        default:
          info = error.code;
          break;
      }

      scaffold.currentState.showSnackBar(SnackBar(content: Text(info, style: TextStyle(fontSize: 16)), backgroundColor: Color(0xffC03D29)));

    });

  }
}