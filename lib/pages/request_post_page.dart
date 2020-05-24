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

  final _nameFieldCtrl = TextEditingController();

  String typeData;
  String type = INSTA;
  bool isLoading = false;
  bool dataLoading = false;
  bool editMode = false;

  @override
  void initState() {
    editMode = widget.request != null;
    if (!editMode)
      widget.request = Request();

    _nameFieldCtrl.text = widget.request.name ?? "";
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
          //padding: EdgeInsets.only(top: 80.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10.0),

                  type == INSTA ? CircleAvatar(
                    backgroundImage: NetworkImage(widget.request.media ?? profilePlaceholder),
                    radius: 50,
                  ) : Image.network(
                    widget.request.media ?? profilePlaceholder,
                    fit: BoxFit.fitWidth,
                    height: 100,
                    width: 100,
                  ),

                  SizedBox(height: 15.0),

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

                  SizedBox(height: 10.0),

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
                      widget.request.name = name;
                    },
                  ),

                  SizedBox(height: 10.0),

                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextFormField(
                            initialValue: widget.request.mediaData,
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
                          enabled: !isLoading,
                          child: dataLoading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)) : Icon(Icons.done, size: 27),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              setState(() { dataLoading = true; });

                              if (type == INSTA) {
                                //From post_utils.dart (getInstagramData)
                                getInstagramData(typeData).then((data) {
                                  widget.request.receiver = widget.receiver.id;
                                  widget.request.receiverName = widget.receiver.name;
                                  widget.request.media = data['url'];
                                  widget.request.mediaData = data['username'];
                                  widget.request.timestamp = Timestamp.now();

                                  setState(() { dataLoading = false; });
                                });
                              } else if (type == MOVIE) {
                                //From post_utils.dart (getMovieData)
                                getMovieData(typeData).then((data) {
                                  if (data['found'] != "True") {
                                    Scaffold.of(context).showSnackBar(alertSnackBar("Dizi/film bulunamadı"));
                                    return;
                                  }

                                  widget.request.receiver = widget.receiver.id;
                                  widget.request.receiverName = widget.receiver.name;
                                  widget.request.name = data['title'];
                                  widget.request.media = data['poster'];
                                  widget.request.mediaData = data['year'];
                                  widget.request.timestamp = Timestamp.now();

                                  setState(() {
                                    _nameFieldCtrl.text = data['title'];
                                    dataLoading = false;
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


                          if (editMode) {
                            _userService.updateRequest(widget.request).then((arg) {
                              setState(() { isLoading = false; });
                              Navigator.pop(context);
                            });

                            return;
                          }

                          _userService.makeRequest(widget.request).then((success) {
                            setState(() { isLoading = false; });
                            HomePage.selectedPage = 1;
                            Navigator.of(context).popUntil(ModalRoute.withName('/home'));
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

}
