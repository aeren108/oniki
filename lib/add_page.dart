import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  String name;
  String rateType;
  int rate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ekle")),
      body: Form(
        key: _formKey,

        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: TextFormField(
                decoration: InputDecoration(hintText: "Şey ismi"),
                onSaved: (value) {
                  name = value;
                },
              ),
            ),

          ],
        )
      ),
    );
  }
}
