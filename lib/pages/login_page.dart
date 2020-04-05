import 'package:flutter/material.dart';
import 'package:oniki/pages/auth_form.dart';
import 'package:oniki/services/auth_service.dart';

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
    _authService.signInWithEmail(email, password).then((user) {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }
}