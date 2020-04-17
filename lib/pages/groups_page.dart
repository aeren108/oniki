import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/pages/group_profile.dart';
import 'package:oniki/services/group_service.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/widgets/gradient_button.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final _userService = UserService.instance;
  final _groupService = GroupService.instance;

  List<Group> _groups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text("Gruplar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: appBarGradient,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          //Groups list
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: FutureBuilder(
              future: _userService.getGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                _groups = snapshot.data;

                if (_groups.isEmpty)
                  return Center(child: Text("Katıldığın hiçbir grup yok.", style: TextStyle(fontSize: 24)));

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ListView.builder(
                    shrinkWrap: true,
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
      )
    );
  }

  void _showJoinGroupBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
        ),
        isScrollControlled: true,
        elevation: 80.0,
        builder: (context) {
          return Container(
            height: 620,
            child: JoinPage(
              onJoin: () { setState(() {}); },
              onError: () {
                Scaffold.of(ctx).showSnackBar(SnackBar(content: Text("Grup bulunamadı"), backgroundColor: alertColor, behavior: SnackBarBehavior.floating));
              },
            )
          );
        }
    );
  }

  void _showCreateGroupBottomSheet(BuildContext ctx) {
    final _formKey = GlobalKey<FormState>();

    String groupName = "";
    bool isLoading = false;

    showModalBottomSheet(
      context: ctx,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
      ),
      isScrollControlled: true,
      elevation: 24.0,
      builder: (context) {
        return isLoading ? Center(child: CircularProgressIndicator()) : Container(
          height: 620,
          child: Form (
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text("Bir Grup Oluştur", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
                Divider(thickness: 3.0, endIndent: 105, indent: 105, color: watermelon),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Grup İsmi',
                          border: OutlineInputBorder()
                        ),
                        onSaved: (name) => groupName = name,
                        validator: (name) {
                          if (name.isEmpty)
                            return "Grup ismi boş olamaz";
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      GradientButton(
                        child: Center(child: Text("Oluştur", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)),
                        colors: pinkBurgundyGrad,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            isLoading = true;
                            _groupService.createGroup(UserService.currentUser, groupName).then((group) {
                              Navigator.pop(context);
                              setState(() {});
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

//TODO: Make group create/join page for
class JoinPage extends StatefulWidget {
  VoidCallback onJoin;
  VoidCallback onError;
  JoinPage({ @required this.onJoin, @required this.onError });

  @override
  _JoinPageState createState() => _JoinPageState(onJoin, onError);
}

class _JoinPageState extends State<JoinPage> {
  final _formKey = GlobalKey<FormState>();

  String groupId;
  bool isLoading = false;

  VoidCallback onJoin;
  VoidCallback onError;

  _JoinPageState(this.onJoin, this.onError);

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: CircularProgressIndicator()) : Form (
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text("Bir Gruba Katıl", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          Divider(thickness: 3.0, endIndent: 110, indent: 110, color: watermelon),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Grup ID',
                        border: OutlineInputBorder()
                    ),
                    onSaved: (id) => groupId = id,
                    validator: (name) {
                      if (name.isEmpty)
                        return "Grup ID'si boş olamaz";
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 20),

                GradientButton(
                  child: Center(child: Text("Katıl", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                  colors: pinkBurgundyGrad,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      setState(() { isLoading = true; });
                      UserService.instance.joinGroup(groupId).then((group) {
                        if (group == null) {
                          setState(() { isLoading = false; });
                          Navigator.pop(context);
                          onError();
                          return;
                        }

                        onJoin();

                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
