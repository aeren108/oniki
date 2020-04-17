import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/services/auth_service.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/widgets/gradient_button.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService.instance;
  final _userService = UserService.instance;

  String name;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı Ayarları", style: TextStyle(fontSize: 20)),
        backgroundColor: watermelon,
        flexibleSpace: appBarGradient,
        elevation: 0.0,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) :
      Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 36.0),
          child: Column(
            children: <Widget>[
              CircleAvatar(backgroundImage: NetworkImage(UserService.currentUser.photo), radius: 40),

              SizedBox(height: 20.0),

              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "İsim"
                ),
                initialValue: UserService.currentUser.name,

                validator: (name) {
                  if (name.isEmpty)
                    return "İsim boş olamaz";
                  return null;
                },

                onSaved: (name) => this.name = name,

              ),

              SizedBox(height: 10),

              GradientButton(
                child: Center(child: Text("KAYDET", style: TextStyle(fontSize: 22))),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() => isLoading = true);

                    UserUpdateInfo info = UserUpdateInfo();
                    info.displayName = name;

                    UserService.currentUser.name = name;
                    _userService.updateUser(UserService.currentUser).then((arg) {
                      Navigator.pop(context);
                      _authService.updateUser(info);
                    });
                  }
                },
                colors: pinkBurgundyGrad
              )
            ],
          ),
        ),
      ),
    );
  }
}
