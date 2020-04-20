import 'package:flutter/material.dart';

import 'package:oniki/constants.dart';
import 'package:oniki/services/auth_service.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/widgets/google_signin_button.dart';
import 'package:oniki/widgets/gradient_button.dart';

abstract class AuthForm extends StatefulWidget {
  final scaffold = GlobalKey<ScaffoldState>();

  String confirmText;
  bool isLoading = false;

  AuthForm(Key key) : super(key: key);

  @override
  AuthFormState createState() => AuthFormState();

  List<Widget> buildForm(BuildContext context);
  List<Widget> buildFooter(BuildContext context);
  void confirmAction(BuildContext context);
}

class AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService.instance;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffff512f ), Color(0xffdd2476)],
  ).createShader(new Rect.fromLTWH(150.0, 300.0, 100.0, 800.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffold,
      body: widget.isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : Container(
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
                      //fontStyle: FontStyle.italic,
                      fontFamily: "Bebas Neue",
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

                            for (Widget w in widget.buildForm(context)) w,

                            SizedBox(height: 15),
                            GradientButton(
                              child: Center(child: Text(widget.confirmText, style: TextStyle(fontSize: 22))),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  _authService.signOut();
                                  widget.confirmAction(context);
                                }
                              },
                              colors: pinkBurgundyGrad
                            ),
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

                _authService.getGoogleAccount().then((googleUser) {
                  if (googleUser == null)
                    return;

                  setState(() => widget.isLoading = true);

                  _authService.authenticateWithGoogle(googleUser).then((user) {
                    UserService.instance.findUser(user.uid).then((usr) {
                      if (usr != null) {
                        UserService.currentUser = usr;
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        UserService.instance.createUser(user.displayName, user.uid, user.photoUrl).then((usr0) {

                          UserService.currentUser = usr0;
                          Navigator.pushReplacementNamed(context, '/home');
                        });
                      }
                    }).catchError((error) {
                      setState(() => widget.isLoading = false);
                    });
                  }).catchError((error) => setState(() => widget.isLoading = false));

                }).catchError((error) => setState(() => widget.isLoading = false));
              }),

              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.buildFooter(context)
              )
            ],
          ),
        ),
      ),
    );
  }
}
