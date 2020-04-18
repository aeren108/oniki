import 'package:flutter/material.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/pages/profile_page.dart';
import 'package:oniki/services/group_service.dart';

class GroupMembers extends StatefulWidget {
  Group group;

  GroupMembers({ @required this.group });

  @override
  _GroupMembersState createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> with AutomaticKeepAliveClientMixin {
  final _groupService = GroupService.instance;

  List<User> members = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  FutureBuilder(
        future: _groupService.getGroupMembers(widget.group),
        builder: (context, snapshot) {
          if ((snapshot.connectionState != ConnectionState.done || !snapshot.hasData) && members.isEmpty)
            return Center(child: CircularProgressIndicator());

          members = snapshot.data;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  User u = members[index];
                  return Column(
                    children: <Widget>[
                      MemberTile(member: u, admin: widget.group.admin),
                      Divider(thickness: 1.0)
                    ]
                  );
                }
            )
          );
        },
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class MemberTile extends StatelessWidget {
  User member;
  String admin;

  MemberTile({ @required this.member, @required this.admin});

  @override
  Widget build(BuildContext context) {
    return (member.id == admin) ? ListTile(
      title: Text(member.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(member.photo),
        radius: 24,
      ),
      trailing: Icon(Icons.event_seat, size: 28),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage.withUser(user: member))),
    ) : ListTile(title: Text(member.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(member.photo),
        radius: 24,
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage.withUser(user: member)))
    );
  }
}
