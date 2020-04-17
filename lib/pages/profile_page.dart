import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/services/auth_service.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/widgets/user_posts.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.pushNamed(context, '/add'), child: Icon(Icons.add, size: 36, color: Colors.white), backgroundColor: Colors.black54,),
      body: (UserService.currentUser == null) ? Center(child: CircularProgressIndicator()) :
        NestedScrollView(
          headerSliverBuilder:(context, innerBoxIsScrolled) => <Widget>[
            SliverAppBar(
              expandedHeight: 190,
              pinned: true,
              backgroundColor: watermelon,
              elevation: 0.5,
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(UserService.currentUser.name, style: TextStyle(fontSize: 22)),
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

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(UserService.currentUser.photo),
                        radius: 42,
                      ),
                    ],
                  )
                ),
              ),
            )
          ],

          body: UserPosts(),
        ),
    );
  }

  void _showBottomSheet(BuildContext c) {
    showModalBottomSheet(
      context: c,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0))
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
