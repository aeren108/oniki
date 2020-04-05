import 'package:flutter/material.dart';
import 'package:oniki/services/auth.dart';
import 'package:oniki/ui/google_signin_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String email, password;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffff512f ), Color(0xffdd2476)],
  ).createShader(new Rect.fromLTWH(150.0, 300.0, 100.0, 800.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Text("ONİKİ",
                  style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      foreground: Paint()..shader = linearGradient
                  )
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  child: Form(
                      key: _formKey,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
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
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.lock),
                                    labelText: "Şifre"
                                ),

                                validator: (pswd) {
                                  if (pswd.length < 6)
                                    return "Şifre en az 6 karakter uzunluğunda olmalı";
                                  return null;
                                },
                                onSaved: (password) { this.password = password; } ,
                              ),

                              SizedBox(height: 15),

                              RaisedButton(
                                padding: const EdgeInsets.all(0.0),
                                textColor: Colors.white,

                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      gradient: LinearGradient(
                                          colors:<Color>[
                                            Color(0xfff7781e),
                                            Color(0xffed154b)
                                          ]
                                      )
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(child: Text("GİRİŞ YAP", style: TextStyle(fontSize: 22),)),
                                ),

                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();

                                    _authService.signInWithEmail(email, password).then((user) {
                                      Navigator.pushReplacementNamed(context, '/home');
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      )
                  ),
                ),
              ),

              SizedBox(height: 35.0),

              Row(
                children: <Widget>[
                  Expanded(
                      child: Divider(indent: 32.0, endIndent: 8.0, color: Colors.black54)
                  ),

                  Text("VEYA", style: TextStyle(fontSize: 16),),

                  Expanded(
                      child: Divider(indent: 8.0, endIndent: 32.0, color: Colors.black54)
                  ),
                ],
              ),

              SizedBox(height: 30.0),

              GoogleSignInButton(onPressed: () {
                _authService.signInWithGoogle().then((user) {
                  print("User logged in: ${user.displayName}" );
                  Navigator.pushReplacementNamed(context, '/home');
                });
              }),

              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
