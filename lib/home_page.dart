import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oniki/item_list.dart';
import 'add_page.dart';
import 'model/item.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Oniki")),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AddPage()
              ));
            },
            child: Icon(Icons.add)
        ),
        body: buildBody()
    );
  }

  Widget buildBody() {
    // if item list is empty return a text which states item list is empty
    if (Item.items.isEmpty)
      return Center(child: Text("Puanlamak için + 'ya bas", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),));
    else
      return ItemList();
  }
}
