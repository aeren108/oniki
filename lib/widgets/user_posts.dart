import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/pages/add_page.dart';
import 'package:oniki/services/user_service.dart';

class UserPosts extends StatefulWidget {
  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  UserService _userService = UserService.instance;
  List<Post> _posts = [];
  Future<List<Post>> _future;

  @override
  Widget build(BuildContext context) {
    _future = _userService.getPosts();

    return RefreshIndicator(

      onRefresh: _refresh,
      child: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (!snapshot.hasData)
            return CircularProgressIndicator();

          _posts = snapshot.data;

          if (_posts.isEmpty)
            return Center(child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text('Burası bomboş ...', style: TextStyle(fontSize: 24)),
            ));

          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _posts.length,
            itemBuilder: (BuildContext context, int index) {
              Post p = _posts[index];
              return Column(
                children: <Widget>[
                  PostTile(post: p),
                  Divider(thickness: 1.0, indent: 15, endIndent: 15)
                ],
              );
            }
          );
        },
      ),
    );
  }

  Future<void> _refresh() {
    setState(() {});
    return _future = _userService.getPosts();
  }

}

class PostTile extends StatelessWidget {
  Post post;

  PostTile({@required this.post});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      subtitle: Text(post.mediaData, style: TextStyle(fontSize: 15)),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(post.mediaUrl),
        radius: 24,
      ),
      trailing: Text("${post.rate.toInt()} / 12", style: TextStyle(fontSize: 21, fontFamily: 'Duldolar', color: watermelon),),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddPage.withPost(post)));
      },
    );
  }
}

