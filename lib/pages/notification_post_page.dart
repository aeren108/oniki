import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/notification.dart' as Notif;
import 'package:oniki/services/user_service.dart';
import 'package:oniki/utils/post_utils.dart';
import 'package:oniki/widgets/gradient_button.dart';

class NotificationPostPage extends StatefulWidget {
  Notif.Notification notif;

  NotificationPostPage({ @required this.notif });

  @override
  _NotificationPostPageState createState() => _NotificationPostPageState();
}

class _NotificationPostPageState extends State<NotificationPostPage> {
  final _userService = UserService.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

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
                    enabled: false,
                    initialValue: widget.notif.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "İsim / Başlık",
                    ),
                  ),

                  SizedBox(height: 10.0),

                  TextFormField(
                    enabled: false,
                    initialValue: widget.notif.mediaData,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Instagram",
                    ),
                  ),

                  SizedBox(height: 35.0),

                  TextFormField(
                    enabled: false,
                    initialValue: widget.notif.desc,
                    maxLines: 2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Mesaj",
                    ),
                  ),

                  SizedBox(height: 20.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${widget.notif.rate.round()}", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(width: 20),
                      RatingBar(
                        initialRating: widget.notif.rate / 2,
                        allowHalfRating: true,
                        glowRadius: 0.1,
                        glowColor: Colors.blueGrey,
                        direction: Axis.horizontal,
                        itemCount: 6,
                        unratedColor: Color(0xb35c5c5c),
                        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rate) {
                          setState(() {
                            widget.notif.rate = rate * 2;
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 35.0),

                  GradientButton(
                    child: Center(child: Text("İsteği Cevapla", style: TextStyle(fontSize: 22, color: Colors.white),)),
                    onPressed: ()  {
                      if (widget.notif.replied) {
                        _scaffoldKey.currentState.showSnackBar(infoSnackBar("Zaten isteği cevapladın"));
                        return;
                      }

                      setState(() { isLoading = true; });

                      _userService.replyRequest(widget.notif).then((success) {
                        setState(() { isLoading = false; });
                        Navigator.pop(context);
                      });
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
