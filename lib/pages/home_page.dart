import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
            label: Text("Ekle", style: TextStyle(fontSize: 16),),
        ),
        body: ItemList()
    );
  }
}
