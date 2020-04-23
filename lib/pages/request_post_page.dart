import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/model/request.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/pages/home_page.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/utils/post_utils.dart';
import 'package:oniki/widgets/gradient_button.dart';

class RequestPostPage extends StatefulWidget {
  User receiver;
  Request request = Request();

  RequestPostPage({ @required this.receiver, this.request });

  @override
  _RequestPostPageState createState() => _RequestPostPageState();
}

class _RequestPostPageState extends State<RequestPostPage> {
  final _userService = UserService.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String username;
  bool isLoading = false;
  bool editMode = false;

  @override
  void initState() {
    editMode = widget.request != null;
    if (!editMode)
      widget.request = Request();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    initialValue: widget.request.name ?? "",
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
                      widget.request.name = name;
                    },
                  ),

                  SizedBox(height: 10.0),

                  TextFormField(
                    initialValue: widget.request.mediaData,
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

                  SizedBox(height: 18.0),
                  Divider(thickness: 1.0),
                  SizedBox(height: 18.0),

                  TextFormField(
                    initialValue: widget.request.desc,
                    maxLines: 2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Mesaj",
                    ),

                    onSaved: (desc) {
                      widget.request.desc = desc;
                    },
                  ),

                  SizedBox(height: 15.0),

                  GradientButton(
                      child: Center(child: Text("İsteği Gönder", style: TextStyle(fontSize: 22, color: Colors.white),)),
                      onPressed: ()  {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          if (widget.request.rejected) {
                            _scaffoldKey.currentState.showSnackBar(infoSnackBar("Bu istek reddedildi"));
                            return;
                          }

                          setState(() { isLoading = true; });

                          //From post_utils.dart
                          getInstagramData(username).then((data) {
                            widget.request.receiver = widget.receiver.id;
                            widget.request.receiverName = widget.receiver.name;
                            widget.request.media = data['url'];
                            widget.request.mediaData = data['username'];
                            widget.request.timestamp = Timestamp.now();

                            if (editMode) {
                              _userService.updateRequest(widget.request).then((arg) {
                                setState(() { isLoading = true; });
                                Navigator.pop(context);
                              });

                              return;
                            }

                            _userService.makeRequest(widget.request).then((success) {
                              setState(() { isLoading = false; });
                              HomePage.selectedPage = 1;
                              Navigator.of(context).popUntil(ModalRoute.withName('/home'));
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
