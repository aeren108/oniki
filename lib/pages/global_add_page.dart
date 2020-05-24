import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/services/group_service.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/utils/post_utils.dart';
import 'package:oniki/widgets/gradient_button.dart';


class GlobalAddPage extends StatefulWidget {
  @override
  _GlobalAddPageState createState() => _GlobalAddPageState();
}

class _GlobalAddPageState extends State<GlobalAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldCtrl = TextEditingController(text: "");

  final _userService = UserService.instance;
  final _groupService = GroupService.instance;

  static const PROFILE_DEST = "Profil";

  Post _post = Post();
  Group _group;
  String typeData;
  String uploadDest = PROFILE_DEST;
  String type = INSTA;

  bool isLoading = false;
  bool groupMode = false;
  bool isTypeDataSet = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: watermelon,
        flexibleSpace: appBarGradient,
        title: Text("Puanla", style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 15.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  loading ? Container(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()) : type == INSTA ? CircleAvatar(
                    backgroundImage: NetworkImage(_post.mediaUrl ?? profilePlaceholder),
                    radius: 50,
                  ) : Image.network(
                    _post.mediaUrl ?? profilePlaceholder,
                    fit: BoxFit.scaleDown,
                    height: 120,
                    width: 100,
                  ),

                  SizedBox(height: 10.0),

                  OutlineButton(
                    highlightElevation: 8.0,
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Text("Yüklenen yer:", style: TextStyle(fontSize: 18)),
                          SizedBox(width: 8.0),
                          SizedBox(
                            width: 180,
                            child: Text(uploadDest,
                              style: TextStyle(fontSize: 18, color: watermelon),
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ],
                      )
                    ),
                    onPressed: () { _showUploadDestinationsBottomSheet(context);},
                    borderSide: BorderSide(style: BorderStyle.solid),
                  ),

                  OutlineButton(
                    highlightElevation: 8.0,
                    child: Container(
                        height: 40,
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Text("Puanlama tipi:", style: TextStyle(fontSize: 18)),
                            SizedBox(width: 8.0),
                            SizedBox(
                              width: 150,
                              child: Text(type,
                                  style: TextStyle(fontSize: 18, color: watermelon),
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ],
                        )
                    ),
                    onPressed: () { _showTypeBottomSheet(context);},
                    borderSide: BorderSide(style: BorderStyle.solid),
                  ),

                  SizedBox(height: 12.0),

                  TextFormField(
                    controller: _nameFieldCtrl,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
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

                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextFormField(
                            initialValue: _post.type == INSTA ? _post.mediaData : _post.name,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                              border: OutlineInputBorder(),
                              labelText: type,
                            ),
                            validator: (username) {
                              if (username.isEmpty)
                                return "$type boş olamaz";
                              return null;
                            },
                            onSaved: (username) {
                              this.typeData = username;
                            },
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: GradientButton(
                          enabled: !loading,
                          child: Icon(Icons.done, size: 27),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              setState(() {
                                loading = true;
                              });

                              if (type == INSTA) {
                                //From post_utils.dart (getInstagramData)
                                getInstagramData(typeData).then((data) {
                                  setState(() {
                                    _post.mediaUrl = data['url'];
                                    _post.mediaData = data['username'];
                                    _post.type = type;

                                    loading = false;
                                    isTypeDataSet = true;
                                  });
                                });
                              } else if (type == MOVIE) {
                                //From post_utils.dart (getMovieData)
                                getMovieData(typeData).then((data) {
                                  if (data['found'] != "True") {
                                    Scaffold.of(context).showSnackBar(alertSnackBar("Dizi/Film bulunamadı"));
                                    setState(() { loading = false; });
                                    return;
                                  }
                                  
                                  setState(() {
                                    _post.name = data['title'];
                                    _post.mediaData = data['year'];
                                    _post.mediaUrl = data['poster'];
                                    _post.type = type;

                                    _nameFieldCtrl.text = data['title'];

                                    loading = false;
                                    isTypeDataSet = true;
                                  });
                                });
                              }
                            }
                          },
                          colors: pinkBurgundyGrad,
                        ),
                      )
                    ],
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

                  ListTile(
                    title: Text("Gizli puanlama:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    trailing: Switch(
                      value: !_post.visibility,
                      onChanged: (value) => _post.visibility = !value,
                    ),
                    onTap: () {
                      setState(() {
                        _post.visibility = !_post.visibility;
                      });
                    },
                  ),

                  SizedBox(height: 10),

                  GradientButton(
                    child: Center(child: Text("Yükle", style: TextStyle(fontSize: 22, color: Colors.white),)),
                    onPressed: ()  {
                      if (!isTypeDataSet) {
                        Scaffold.of(context).showSnackBar(alertSnackBar("Instagram hesabı belirlenmedi"));
                        return;
                      }
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        setState(() { isLoading = true; });

                        _post.owner = UserService.currentUser.name;
                        _post.ownerId = UserService.currentUser.id;
                        _post.timestamp = Timestamp.now();

                        if (groupMode) {
                          _groupService.createPost(_group, _post).then((post) {
                            setState(() {
                              isLoading = false;
                              _post = Post();
                            });
                            Scaffold.of(context).showSnackBar(infoSnackBar("Puanlama başarıyla yüklendi"));
                          });
                        } else {
                          _userService.createPost(_post).then((post) {
                            setState(() {
                              isLoading = false;
                              _post = Post();
                            });
                            Scaffold.of(context).showSnackBar(infoSnackBar("Puanlama başarıyla yüklendi"));
                          });
                        }

                        setState(() {
                          loading = false;
                          isTypeDataSet = false;
                        });
                      }
                    },
                    colors: pinkBurgundyGrad
                  ),

                  SizedBox(height: 10)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showUploadDestinationsBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Container(
          color: Colors.transparent,
          height: 400,
          child: Column(
            children: <Widget>[
              SizedBox(height: 12.0),

              ListTile(
                title: Text(PROFILE_DEST, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                leading: Icon(Icons.person, size: 30),
                onTap: () {
                  setState(() {
                    uploadDest = PROFILE_DEST;
                    groupMode = false;
                  });

                  Navigator.pop(context);
                },
              ),

              Divider(thickness: 1.0, indent: 12.0, endIndent: 12.0),

              for (var group in UserService.currentUser.groups) Column(
                children: <Widget>[
                  ListTile(
                    title: Text(group.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    leading: Icon(Icons.group, size: 30),
                    onTap: () {
                      setState(() {
                        uploadDest = group.name;
                        groupMode = true;
                        _group = group;
                      });

                      Navigator.pop(context);
                    },
                  ),
                  Divider(thickness: 1.0, indent: 12.0, endIndent: 12.0)
                ],
              )
            ],
          ),
        );
      }
    );
  }

  void _showTypeBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        builder: (context) {
          return Container(
            color: Colors.transparent,
            height: 400,
            child: Column(
              children: <Widget>[
                SizedBox(height: 12.0),

                ListTile(
                  title: Text(INSTA, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  leading: Icon(Icons.account_circle, size: 30),
                  onTap: () {
                    setState(() {
                      type = INSTA;
                    });

                    Navigator.pop(context);
                  },
                ),

                Divider(thickness: 1.0, indent: 12.0, endIndent: 12.0),

                ListTile(
                  title: Text(MOVIE, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  leading: Icon(Icons.local_movies, size: 30),
                  onTap: () {
                    setState(() {
                      type = MOVIE;
                    });

                    Navigator.pop(context);
                  },
                ),

              ],
            ),
          );
        }
    );
  }

  @override
  void dispose() {
    _nameFieldCtrl.dispose();
    super.dispose();
  }

}
