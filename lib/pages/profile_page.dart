import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/services/auth_service.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/widgets/user_posts.dart';

class ProfilePage extends StatefulWidget {

  User user = UserService.currentUser;

  ProfilePage();
  ProfilePage.withUser({ @required this.user });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Widget> actionWidgets = [];
  bool isCurrentUser;

  @override
  void initState() {
    isCurrentUser = widget.user.id == UserService.currentUser.id;

    if (isCurrentUser)
      actionWidgets = <Widget>[IconButton(icon: Icon(Icons.menu), onPressed: () {_showBottomSheet(context);})];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (widget.user == null) ? Center(child: CircularProgressIndicator()) :
        NestedScrollView(
          headerSliverBuilder:(context, innerBoxIsScrolled) => <Widget>[
            SliverAppBar(
              expandedHeight: 190,
              pinned: true,
              backgroundColor: watermelon,
              elevation: 0.0,
              centerTitle: true,
              actions: actionWidgets,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.user.name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: pinkPurpleGrad
                    )
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.user.photo),
                        radius: 45,
                      ),
                    ),
                  )
                ),
              ),
            )
          ],

          body: IgnorePointer(
            ignoring: !isCurrentUser,
            child: UserPosts(user: widget.user, isPrivate: !isCurrentUser)
          ),
        ),
    );
  }

  void _showBottomSheet(BuildContext c) {
    showModalBottomSheet(
      context: c,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          height: 400,
          child: Column(
            children: <Widget>[

              SizedBox(height: 5.0),
              ListTile(
                title: Text('Profili Düzenle', style: TextStyle(fontSize: 17)),
                leading: Icon(Icons.edit, color: Colors.black54, size: 28),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/user-settings');
                },
              ),
              Divider(thickness: 0.4, indent: 20, endIndent: 20, color: Colors.black87),
              ListTile(
                title: Text('Çıkış Yap', style: TextStyle(fontSize: 17)),
                leading: Icon(Icons.exit_to_app, color: Colors.black54, size: 28),
                onTap: () {
                  Navigator.pop(context);
                  AuthService.instance.signOut();
                  Navigator.pushReplacementNamed(context, "/register");
                },
              )
            ],
          ),
        );
      }
    );
  }
}
