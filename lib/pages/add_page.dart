import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oniki/data/database.dart';

import '../model/item.dart';

class AddPage extends StatefulWidget {
  Item _item = Item("", "", _AddPageState.NORMAL, 0);

  AddPage.withItem(this._item);
  AddPage();

  @override
  _AddPageState createState() => _AddPageState.withItem(_item);
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final db = ItemDatabase();

  Item _item;

  static const String NORMAL = "";
  static const String BACIM = "Bacim";
  static const String AS = "As";
  String groupVal = NORMAL;

  _AddPageState.withItem(this._item);
  _AddPageState() { _item = Item("", "", NORMAL, 0); }

  @override
  void initState() {
    super.initState();
    groupVal = _item.rateType;
  }

  handleRadio(String val) {
    setState(() {
      switch (val) {
        case NORMAL:
          groupVal = NORMAL;
          _item.rateType = NORMAL;
          break;
        case BACIM:
          groupVal = BACIM;
          _item.rateType = BACIM;
          break;
        case AS:
          groupVal = AS;
          _item.rateType = AS;
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
                            initialValue: _item.name,
                            validator: (String val) {
                              //TODO: Handle name validation
                            }, onSaved: (String val) {
                              _item.name = val;
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
                            initialValue: _item.username,
                            validator: (String val) {
                              //TODO: Handle username validation
                            },
                            onSaved: (String val) {
                              _item.instaname = val;
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
                            "Sana puanım ${_item.rate}",
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ),
                          Expanded(
                            child: Padding (
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Slider(
                                  value: _item.rate.toDouble(),
                                  min: 0.0,
                                  max: 12.0,
                                  divisions: 12,
                                  onChanged: (value) {
                                    setState(() {
                                      _item.rate = value.toInt();
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

                              if (_item.id == null)
                                db.createItem(_item);
                              else
                                db.updateItem(_item);

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
                            if (_item.id != null)
                              db.deleteItem(_item.id);
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
