import 'package:flutter/material.dart';
import 'package:oniki/services/auth_service.dart';
import 'package:oniki/ui/google_signin_button.dart';

abstract class AuthForm extends StatefulWidget {
  String confirmText;

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

                            for (Widget w in widget.buildForm(context)) w,

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
                                child: Center(child: Text(widget.confirmText, style: TextStyle(fontSize: 22),)),
                              ),

                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  widget.confirmAction(context);
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
                children: widget.buildFooter(context)
              )
            ],
          ),
        ),
      ),
    );
  }
}
