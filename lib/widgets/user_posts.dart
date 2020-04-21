import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/pages/add_page.dart';
import 'package:oniki/services/user_service.dart';

class UserPosts extends StatefulWidget {
  User user;
  bool isPrivate = false;

  UserPosts({ @required this.user, this.isPrivate});

  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  final UserService _userService = UserService.instance;

  List<Post> _posts = [];
  Future<List<Post>> _future;

  @override
  Widget build(BuildContext context) {
    _future = _userService.getPosts(widget.user);

    return RefreshIndicator(

      onRefresh: () {
        setState(() {});
        return _future = _userService.getPosts(widget.user);
      },
      child: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          _posts = snapshot.data;

          if (_posts.isEmpty)
            return Center(child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text("Puanlamak için '+'ya bas", style: TextStyle(fontSize: 24)),
            ));

          if (widget.isPrivate) {
            for (int i = 0; i < _posts.length; i++) {
              Post p = _posts[i];

              if (!p.visibility) {
                _posts.remove(p);
                i--;
              }
            }
          }

          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _posts.length,
            itemBuilder: (BuildContext context, int index) {
              Post p = _posts[index];
              return Column(
                children: <Widget>[
                  Dismissible(
                    key: Key(p.id),
                    background: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.delete_forever, color: Colors.white, size: 38)
                        ),
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    child: PostTile(post: p),
                    onDismissed: (direction) {
                      _userService.deletePost(p);
                      setState(() { _posts.remove(p); });
                    },
                  ),
                  Divider(thickness: 1.0, indent: 15, endIndent: 15)
                ],
              );
            }
          );
        },
      ),
    );
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
      trailing: Text(post.rate.floor().toString(),
        style: TextStyle(fontSize: 32, color: watermelon, fontFamily: "Faster One")
      ),

      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddPage.withPost(post, null)));
      },
    );
  }
}

