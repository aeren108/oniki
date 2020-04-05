
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oniki/services/auth_service.dart';
import 'package:oniki/ui/item_list.dart';
import 'add_page.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Oniki")),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AddPage()
              ));
            },
            icon: Icon(Icons.add),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            label: Text("Ekle", style: TextStyle(fontSize: 17)),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 12,
                child: ItemList()
            ),
            Expanded(
              flex: 1,
              child: RaisedButton(
                child: Text("Çıkış Yap"),
                onPressed: () {
                  AuthService.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/register');
                },
              ),
            )
          ],
        )
    );
  }
}
