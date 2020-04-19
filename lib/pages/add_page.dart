import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:oniki/constants.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/services/group_service.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/widgets/gradient_button.dart';
import 'package:oniki/utils/post_utils.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState(post, group);

  Post post = Post();
  Group group;

  AddPage.withPost(this.post, this.group);
  AddPage(this.group);
}

class _AddPageState extends State<AddPage> {
  var _formKey = GlobalKey<FormState>();
  final _userService = UserService.instance;
  final _groupService = GroupService.instance;

  Post _post;
  Group _group;
  String username;

  bool isLoading = false;
  bool editMode = false;
  bool groupMode;

  _AddPageState(this._post, this._group) {
    editMode = _post.id != null;
    groupMode = _group != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: watermelon,
        flexibleSpace: appBarGradient,
        title: Text("Puanla", style: TextStyle(fontSize: 22)),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                initialValue: _post.name,
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
                  _post.name = name;
                },
              ),

              SizedBox(height: 10),

              TextFormField(
                initialValue: _post.mediaData,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Insta",

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

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${_post.rate.round()}", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(width: 20),
                  RatingBar(
                    initialRating: _post.rate / 2,
                    allowHalfRating: true,
                    glowRadius: 0.1,
                    glowColor: Colors.blueGrey,
                    direction: Axis.horizontal,
                    itemCount: 6,
                    unratedColor: Color(0xb35c5c5c),
                    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rate) {
                      setState(() {
                        _post.rate = rate * 2;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Gizli:", style: TextStyle(fontSize: 20)),
                  Checkbox(
                    activeColor: watermelon,
                    value: !_post.visibility,
                    onChanged: (value) {
                      setState(() {
                        _post.visibility = !value;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              GradientButton(
                child: Center(child: Text("Yükle", style: TextStyle(fontSize: 22, color: Colors.white),)),
                onPressed: ()  {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    setState(() {
                      isLoading = true;
                    });

                    //From post_utils.dart
                    getInstagramData(username).then((data) {
                      _post.mediaUrl = data['url'];
                      _post.mediaData = data['username'];
                      _post.type = "NORMAL";
                      _post.owner = UserService.currentUser.name;
                      _post.ownerId = UserService.currentUser.id;
                      _post.timestamp = Timestamp.now();

                      if (!groupMode) {
                        if (editMode)
                          _userService.updatePost(_post).then((arg) => Navigator.pop(context));
                        else
                          _userService.createPost(_post).then((arg) => Navigator.pop(context));
                      } else {
                        if (editMode)
                          _groupService.updatePost(widget.group, _post).then((arg) => Navigator.pop(context));
                        else
                          _groupService.createPost(widget.group, _post).then((arg) => Navigator.pop(context));
                      }

                    });
                  }
                },
                colors: pinkBurgundyGrad
              ),
            ],
          ),
        ),
      ),
    );
  }
}
