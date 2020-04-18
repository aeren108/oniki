import 'package:flutter/material.dart';

import 'package:oniki/model/group.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/services/group_service.dart';
import 'package:oniki/services/user_service.dart';

import '../constants.dart';
import 'add_page.dart';

class GroupPosts extends StatefulWidget{
  Group group;

  GroupPosts({ @required this.group });

  @override
  _GroupPostsState createState() => _GroupPostsState();
}

class _GroupPostsState extends State<GroupPosts> with AutomaticKeepAliveClientMixin {
  final _groupService = GroupService.instance;

  List<Post> _posts = [];
  Future<List<Post>> _future;

  @override
  Widget build(BuildContext context) {
    _future = _groupService.getGroupPosts(widget.group);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddPage(widget.group))),
        child: Icon(Icons.add, size: 36, color: Colors.white),
        backgroundColor: Colors.black54,),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return _future = _groupService.getGroupPosts(widget.group);
        },
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if ((snapshot.connectionState != ConnectionState.done || !snapshot.hasData) && _posts.isEmpty)
              return Center(child: CircularProgressIndicator());

            _posts = snapshot.data;

            return ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) => Column(
                children: <Widget>[
                  GroupPostTile(post: _posts[index], group: widget.group),
                  Divider(thickness: 1.0)
                ],
              )
            );

          },
        ),
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class GroupPostTile extends StatelessWidget {
  Post post;
  Group group;

  GroupPostTile({ @required this.post, @required this.group });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      subtitle: Text(post.mediaData, style: TextStyle(fontSize: 15)),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(post.mediaUrl),
        radius: 24,
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            Text("${post.rate.toInt()} / 12", style: TextStyle(fontSize: 21, fontFamily: 'Duldolar', color: watermelon)),
            Text(post.owner, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700))
          ],
        ),
      ),
      onTap: () {
        if (UserService.currentUser.id == post.ownerId)
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPage.withPost(post, group)));
      },
    );
  }
}

