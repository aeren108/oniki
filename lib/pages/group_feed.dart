import 'package:flutter/material.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/pages/group_posts.dart';
import 'package:oniki/services/group_service.dart';


class GroupFeed extends StatefulWidget {
  Group group;

  GroupFeed({ @required this.group});

  @override
  _GroupFeedState createState() => _GroupFeedState();
}

class _GroupFeedState extends State<GroupFeed> {
  final _groupService = GroupService.instance;

  Future<List<Post>> _future;

  @override
  Widget build(BuildContext context) {
    _future = _groupService.getGroupFeed(widget.group);

    return Scaffold(
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return _future = _groupService.getGroupFeed(widget.group);
          },
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if ((snapshot.connectionState != ConnectionState.done || !snapshot.hasData) && widget.group.feed.isEmpty)
                return Center(child: CircularProgressIndicator());

              return ListView.builder(
                itemCount: widget.group.feed.length,
                itemBuilder: (context, index) => Column(
                  children: <Widget>[
                    IgnorePointer(
                      ignoring: true,
                      child: GroupPostTile(post: widget.group.feed[index], group: widget.group),
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
}
