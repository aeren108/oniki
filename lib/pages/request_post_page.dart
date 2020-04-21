import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/model/request.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/utils/post_utils.dart';
import 'package:oniki/widgets/gradient_button.dart';

class RequestPostPage extends StatefulWidget {
  User receiver;

  RequestPostPage({@required this.receiver });

  @override
  _RequestPostPageState createState() => _RequestPostPageState();
}

class _RequestPostPageState extends State<RequestPostPage> {
  final _userService = UserService.instance;
  final _formKey = GlobalKey<FormState>();

  Request _request = Request();

  String username;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: watermelon,
        flexibleSpace: appBarGradient,
        title: Text("Puanlama İsteği", style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 80.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  TextFormField(
                    initialValue: _request.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "İsim / Başlık",

                    ),
                    validator: (name) {
                      if (name.isEmpty)
                        return "İsim boş olamaz";
                      return null;
                    },
                    onSaved: (name) {
                      _request.name = name;
                    },
                  ),

                  SizedBox(height: 10.0),

                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Instagram",

                    ),
                    validator: (username) {
                      if (username.isEmpty)
                        return "Insta boş olamaz";
                      return null;
                    },
                    onSaved: (username) {
                      this.username = username;
                    },
                  ),

                  SizedBox(height: 35.0),

                  TextFormField(
                    initialValue: "",
                    maxLines: 2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Mesaj",
                    ),

                    onSaved: (desc) {
                      _request.desc = desc;
                    },
                  ),

                  SizedBox(height: 15.0),

                  GradientButton(
                      child: Center(child: Text("İsteği Gönder", style: TextStyle(fontSize: 22, color: Colors.white),)),
                      onPressed: ()  {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          setState(() { isLoading = true; });

                          //From post_utils.dart
                          getInstagramData(username).then((data) {
                            _request.receiver = widget.receiver.id;
                            _request.receiverName = widget.receiver.name;
                            _request.media = data['url'];
                            _request.timestamp = Timestamp.now();

                            _userService.makeRequest(_request).then((success) {
                              setState(() { isLoading = false; });
                              Navigator.pop(context);
                            });

                          });
                        }
                      },
                      colors: pinkBurgundyGrad
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
