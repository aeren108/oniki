import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:oniki/constants.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/pages/group_feed.dart';
import 'package:oniki/pages/group_members.dart';
import 'package:oniki/pages/group_posts.dart';
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
  final _userService = UserService.instance;

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
        title: Text(widget.group.name, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: TabBar(
                controller: _tabController,
                indicatorWeight: 3.0,
                indicatorColor: watermelon,
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.dashboard)),
                  Tab(icon: Icon(Icons.star)),
                  Tab(icon: Icon(Icons.person))
                ]
              ),
            ),
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          GroupFeed(group: widget.group),
          GroupPosts(group:  widget.group),
          GroupMembers(group: widget.group)
        ],
      )
    );
  }

  //TODO: Admin panel
  void _showMenuBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
      ),
      builder: (context) {
        return Container(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: buildBottomSheetItems(widget.group.admin, context),
            ),
          )
        );
      }
    );
  }

  List<Widget> buildBottomSheetItems(String admin, BuildContext ctx) {
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
        title: Text("Gruptan ayrıl", style: TextStyle(fontSize: 17)),
        leading: Icon(Icons.cancel, color: Colors.black54, size: 28),
        onTap: () {
          _userService.leaveGroup(widget.group).then((arg) {
            Navigator.pop(ctx);
            Navigator.pop(context);
          });
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
    ];
  }
}
