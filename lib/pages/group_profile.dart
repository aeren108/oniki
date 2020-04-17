import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/services/group_service.dart';

class GroupProfile extends StatefulWidget {
  Group group;

  GroupProfile({ @required this.group});

  @override
  _GroupProfileState createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> with SingleTickerProviderStateMixin {
  final _groupService = GroupService.instance;

  TabController _tabController;

  @override
  void initState() {
    _tabController =  TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name, style: TextStyle(fontSize: 23)),
        centerTitle: true,
        backgroundColor: watermelon,
        flexibleSpace: appBarGradient,
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 3.0,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.dashboard)),
            Tab(icon: Icon(Icons.star)),
            Tab(icon: Icon(Icons.person))
          ]
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildGroupFeed(context),
          _buildGroupPosts(context),
          _buildMembersTab(context)
        ],
      )
    );
  }

  Widget _buildGroupFeed(BuildContext context) {
    return Center(child: Text("Gruptaki kullanıcıların puanladıkları", style: TextStyle(fontSize: 24)));
  }

  Widget _buildGroupPosts(BuildContext context) {
    return Center(child: Text("Grup içi puanlamalar", style: TextStyle(fontSize: 24)));
  }

  Widget _buildMembersTab(BuildContext context) {
    List<User> members = [];

    return FutureBuilder(
      future: _groupService.getGroupMembers(widget.group),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        members = snapshot.data;

        return ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            User u = members[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(u.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(u.photo),
                      radius: 24,
                    ),
                  ),
                  Divider(thickness: 1.0)
                ],
              ),
            );
          }
        );
      },
    );
  }
}
