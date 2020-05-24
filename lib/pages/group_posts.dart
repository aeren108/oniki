import 'package:flutter/material.dart';

import 'package:oniki/model/group.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/services/group_service.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/widgets/tile_image.dart';

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
            if ((snapshot.connectionState != ConnectionState.done || !snapshot.hasData) && widget.group.posts.isEmpty)
              return Center(child: CircularProgressIndicator());

            return ListView.builder(
              itemCount: widget.group.posts.length,
              itemBuilder: (context, index) => Column(
                children: <Widget>[
                  IgnorePointer(
                    ignoring: (widget.group.posts[index].ownerId != UserService.currentUser.id),
                    child: Dismissible(
                      key: Key(widget.group.posts[index].id),
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
                      child: GroupPostTile(post: widget.group.posts[index], group: widget.group),
                      onDismissed: (direction) {
                        GroupService.instance.deletePost(widget.group, widget.group.posts[index]);
                        setState(() { widget.group.posts.remove(widget.group.posts[index]); });
                      },
                    ),
                  ),
                  Divider(thickness: 1.0, indent: 10, endIndent: 10)
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
      leading: TileImage(post: post, size: 48),
      trailing: Column(
        children: <Widget>[
          Text(post.rate.floor().toString(),
            style: TextStyle(fontSize: 31, color: watermelon, fontFamily: "Faster One")
          ),
          Text(post.owner, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))
        ],
      ),
      onTap: () {
        if (UserService.currentUser.id == post.ownerId)
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPage.withPost(post, group)));
      },
    );
  }
}

