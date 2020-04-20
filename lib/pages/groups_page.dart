import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/pages/group_profile.dart';
import 'package:oniki/services/group_service.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/widgets/gradient_button.dart';
import 'package:oniki/widgets/group_action.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final _userService = UserService.instance;
  final _groupService = GroupService.instance;

  Future<List<Group>> _future;
  List<Group> _groups = [];

  @override
  Widget build(BuildContext context) {
    _future = _userService.getGroups();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Gruplar", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: appBarGradient,
      ),

      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return _future = _userService.getGroups();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //Groups list
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if ((snapshot.connectionState != ConnectionState.done || !snapshot.hasData) && _groups.isEmpty)
                    return Center(child: CircularProgressIndicator());

                  List<Group> fetchedGroups = snapshot.data;
                  for (int i = 0; i < fetchedGroups.length; i++) {
                    var g1 = fetchedGroups[i];
                    int duplicateCount = 0;

                    for (var g2 in _groups) {

                      if (g1 == g2) {
                        fetchedGroups.remove(g1);
                        duplicateCount++;
                      }
                    }

                    i -= duplicateCount;
                  }

                  _groups.addAll(fetchedGroups);

                  if (_groups.isEmpty)
                    return Center(child: Text("Katıldığın hiçbir grup yok.", style: TextStyle(fontSize: 24)));

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: SizedBox(
                      height: 400,
                      child: ListView.builder(
                        itemCount: _groups.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              GroupTile(group: _groups[index]),
                              Divider(thickness: 1, indent: 12.0, endIndent: 12.0)
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Bir gruba katıl", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: watermelon)),
                    leading: Icon(Icons.group_add, size: 36, color: Colors.black54),
                    onTap: () { _showJoinGroupBottomSheet(context); },
                  ),

                  Divider(thickness: 1, indent: 20, endIndent: 20),

                  ListTile(
                    title: Text("Bir grup oluştur", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: watermelon)),
                    leading: Icon(Icons.add, size: 36, color: Colors.black54),
                    onTap: () { _showCreateGroupBottomSheet(context); }
                  ),
                ],
              ),
            ),

          ],
        ),
      )
    );
  }

  void _showJoinGroupBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
        ),
        isScrollControlled: true,
        elevation: 80.0,
        builder: (context) {
          return Container(
            height: 620,
            child: GroupAction(
              actionType: ActionType.JOIN,
              onSuccess: () {
                setState(() {});
              },
              onError: () {
                alertSnackBar("Grup bulunamadı");
              },
            )
          );
        }
    );
  }

  void _showCreateGroupBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
      ),
      isScrollControlled: true,
      elevation: 24.0,
      builder: (context) {
        return Container(
          height: 620,
          child: GroupAction(
            actionType: ActionType.CREATE,
            onSuccess: () {
              setState(() {});
            },
            onError: () {
              alertSnackBar("Bir şeyler ters gitti");
            },
          )
        );
      }
    );
  }
}

class GroupTile extends StatelessWidget {
  Group group;

  GroupTile({@required this.group});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(group.name, style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold)),
      leading: Icon(Icons.people, size: 32),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => GroupProfile(group: group)));
      },
    );
  }
}
