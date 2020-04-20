import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/services/group_service.dart';
import 'package:oniki/services/user_service.dart';
import 'package:oniki/widgets/gradient_button.dart';

//Widget for join and create group pages;
class GroupAction extends StatefulWidget {
  ActionType actionType;
  VoidCallback onError;
  VoidCallback onSuccess;

  String title, labelText, buttonText;
  Future task(String data) => (actionType == ActionType.CREATE) ? GroupService.instance.createGroup(UserService.currentUser, data) :
                                                                  UserService.instance.joinGroup(data);

  GroupAction({this.actionType, this.onError, this.onSuccess}) {
    prepareData(actionType);
  }

  @override
  _GroupActionState createState() => _GroupActionState();

  void prepareData(ActionType type) {
    switch (type) {
      case ActionType.JOIN:
        title = "Bir Gruba Katıl";
        labelText = "Grup ID";
        buttonText = "Katıl";
        break;
      case  ActionType.CREATE:
        title = "Bir Grup Oluştur";
        labelText = "Grup İsmi";
        buttonText = "Oluştur";
        break;
    }
  }
}

class _GroupActionState extends State<GroupAction> {
  final _formKey = GlobalKey<FormState>();

  String groupData;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return  isLoading ? Center(child: CircularProgressIndicator()) : Form (
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(widget.title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          Divider(thickness: 3.0, endIndent: 110, indent: 110, color: watermelon),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: widget.labelText,
                      border: OutlineInputBorder()
                  ),
                  maxLength: 25,
                  onSaved: (id) => groupData = id,
                  validator: (name) {
                    if (name.isEmpty)
                      return "Bu alan boş olamaz";
                    return null;
                  },
                ),

                SizedBox(height: 20),

                GradientButton(
                  child: Center(child: Text(widget.buttonText, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                  colors: pinkBurgundyGrad,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      setState(() { isLoading = true; });
                      widget.task(groupData).then((arg) {
                        if (arg == null) {
                          setState(() { isLoading = false; });
                          Navigator.pop(context);
                          widget.onError();
                          return;
                        }

                        widget.onSuccess();
                        setState(() { isLoading = false; });
                        Navigator.pop(context);

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

enum ActionType {
  CREATE, JOIN
}
