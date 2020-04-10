import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/ui/user_posts.dart';

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
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.pushNamed(context, '/add'), child: Icon(Icons.add), backgroundColor: watermelon,),
      body: (UserService.currentUser == null) ? Center(child: CircularProgressIndicator()) :
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 190,
              pinned: true,
              //title:
              backgroundColor: watermelon,
              elevation: 0.0,
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {Navigator.pushNamed(context, '/user-settings');}, //TODO: Create user settings page
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {},
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(UserService.currentUser.name, style: TextStyle(fontSize: 24)),
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        watermelon,
                        Color(0xffff3b55)
                      ]
                    )
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(UserService.currentUser.photo),
                        radius: 40,
                      ),
                    ],
                  )
                ),
              ),
            ),
            SliverFillRemaining(
              child: UserPosts()
            )
          ],
        )
    );
  }
}
