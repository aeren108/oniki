import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oniki/data/database.dart';

import '../model/item.dart';

class AddPage extends StatefulWidget {
  Item _item = Item("", "", _AddPageState.NORMAL, 0);

  AddPage.withItem(this._item);
  AddPage();

  @override
  _AddPageState createState() => _AddPageState(_item);
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final db = ItemDatabase();

  Item item = Item("", "", NORMAL, 0);

  static const String NORMAL = "";
  static const String BACIM = "Bacim";
  static const String AS = "As";
  String groupVal = NORMAL;

  _AddPageState(this.item);

  @override
  void initState() {
    super.initState();
    groupVal = item.rateType;
  }

  handleRadio(String val) {
    setState(() {
      switch (val) {
        case NORMAL:
          groupVal = NORMAL;
          item.rateType = NORMAL;
          break;
        case BACIM:
          groupVal = BACIM;
          item.rateType = BACIM;
          break;
        case AS:
          groupVal = AS;
          item.rateType = AS;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ekle")),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Form(
              key: _formKey,

              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text (
                          "İsim: ",
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(hintText: "İsmi ?"),
                            initialValue: item.name,
                            validator: (String val) {
                              //TODO: Handle name validation
                            }, onSaved: (String val) {
                              item.name = val;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text (
                          "Insta: ",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(hintText: "Insta usernamesi"),
                            initialValue: item.username,
                            validator: (String val) {
                              //TODO: Handle username validation
                            }, onSaved: (String val) {
                            item.instaname = val;
                          },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 10.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Sana puanım ${item.rate}",
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ),
                          Expanded(
                            child: Padding (
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Slider(
                                  value: item.rate.toDouble(),
                                  min: 0.0,
                                  max: 12.0,
                                  divisions: 12,
                                  onChanged: (value) {
                                    setState(() {
                                      item.rate = value.toInt();
                                    });
                                  },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Normal",
                              style: TextStyle(fontSize: 16),
                            ),
                            Radio(
                              value: NORMAL,
                              groupValue: groupVal,
                              activeColor: Colors.orange,
                              onChanged: handleRadio,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Bacım",
                              style: TextStyle(fontSize: 16),
                            ),
                            Radio(
                              value: BACIM,
                              groupValue: groupVal,
                              activeColor: Colors.orange,
                              onChanged: handleRadio,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "As",
                              style: TextStyle(fontSize: 16),
                            ),
                            Radio(
                              value: AS,
                              groupValue: groupVal,
                              activeColor: Colors.orange,
                              onChanged: handleRadio,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Icon(Icons.done),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              if (item.id == null)
                                db.createItem(item);
                              else
                                db.updateItem(item);

                              Navigator.pop(context);
                            }
                          },
                        ),
                      ), Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Icon(Icons.delete),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (item.id != null)
                              db.deleteItem(item.id);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )
            ),
          ]
        ),
      ),
    );
  }
}
