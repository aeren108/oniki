import 'package:flutter/material.dart';

import 'add_page.dart';
import 'model/item.dart';

class ItemList extends StatelessWidget {
  final List<Item> _items = Item.items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int index) {
        Item item = _items[index];
        return Column(
          children: <Widget>[
            ItemTile(item),
            Divider(thickness: 1, indent: 10, endIndent: 10, color: Colors.black54)
          ],
        );
      });
  }
}

class ItemTile extends StatelessWidget {
  final Item _item;

  ItemTile(this._item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_item.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
      subtitle: Text("insta: ${_item.username}", style: TextStyle(fontSize: 16, color: Colors.black87),),
      leading: FutureBuilder(
        future: _item.getPicURL(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          print("INFO: ${snapshot.toString()}");
         if (snapshot.hasData) {
           return CircleAvatar(
             backgroundImage: NetworkImage(snapshot.data),
             radius: 28,
           );
         }
         return CircleAvatar(backgroundImage: NetworkImage(Item.PLACEHOLDER), radius: 28,);
        }
      ),
      trailing: Text("${_item.rateType}  ${_item.rate}/12",
        style: TextStyle(fontSize: 19, color: Colors.black54, fontWeight: FontWeight.bold, fontFamily: 'Duldolar' ),
      ),

      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddPage.withItem(_item)
        ));
      }
    );
  }
}

