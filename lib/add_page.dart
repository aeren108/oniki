import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/item.dart';
import 'item_list.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();

  Item item = Item("İsim", "username", NORMAL, 0);

  static const String NORMAL = "N";
  static const String BACIM = "B";
  static const String AS = "A";
  String groupVal = NORMAL;

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
                            validator: (String val) {
                              //TODO: Handle username validation
                            }, onSaved: (String val) {
                            item.username = val;
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
                  RaisedButton(
                    child: Text("Kaydet",),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        Item.items.add(item);
                        Navigator.pop(context);
                      }
                    },
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
