import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/services/group_service.dart';
import 'package:oniki/services/user_service.dart';

class GroupProfile extends StatefulWidget {
  Group group;

  GroupProfile({ @required this.group});

  @override
  _GroupProfileState createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> with SingleTickerProviderStateMixin {
  final _groupService = GroupService.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController _tabController;

  @override
  void initState() {
    _tabController =  TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.group.name, style: TextStyle(fontSize: 23)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: watermelon,
        flexibleSpace: appBarGradient,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () { _showMenuBottomSheet(context); },
          )
        ],
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
                ],
              );
            }
          ),
        );
      },
    );
  }

  //TODO: Admin panel
  void _showMenuBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0))
      ),
      builder: (context) {
        return Container(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: buildMemberSheetItems(widget.group.admin, ctx),
            ),
          )
        );
      }
    );
  }

  List<Widget> buildMemberSheetItems(String admin, BuildContext ctx) {
    return (UserService.currentUser.id == admin) ? <Widget>[
      ListTile(
        title: Text('Grubu Sil', style: TextStyle(fontSize: 17)),
        leading: Icon(
            Icons.delete, color: Colors.black54, size: 28),
        onTap: () async {
          await _groupService.deleteGroup(widget.group);
          Navigator.pop(context);
          Navigator.pop(ctx);
        },
      ),

      Divider(thickness: 0.4, indent: 20, endIndent: 20, color: Colors.black87),

      ListTile(
        title: SelectableText(widget.group.id, style: TextStyle(fontSize: 17)),
        leading: Icon(Icons.insert_link, color: Colors.black54, size: 28),
        trailing: IconButton(
          icon: Icon(Icons.content_copy, color: Colors.black54, size: 26),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: widget.group.id));
            Navigator.pop(context);
            _scaffoldKey.currentState.showSnackBar(infoSnackBar("Grup ID'si panoya kopyalandı"));
          },
        ),
      ),
    ] : <Widget>[
      ListTile(
        title: SelectableText(widget.group.id, style: TextStyle(fontSize: 17)),
        leading: Icon(Icons.insert_link, color: Colors.black54, size: 28),
        trailing: IconButton(
          icon: Icon(Icons.content_copy, color: Colors.black54, size: 26),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: widget.group.id));
            Navigator.pop(context);
            _scaffoldKey.currentState.showSnackBar(infoSnackBar("Grup ID'si panoya kopyalandı"));
          },
        ),
      ),
    ];
  }

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
    ) : ListTile(title: Text(member.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(member.photo),
        radius: 24,
      ),
    );
  }
}

