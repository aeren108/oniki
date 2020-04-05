import 'package:flutter/material.dart';
import 'package:oniki/data/database.dart';

import '../pages/add_page.dart';
import '../model/item.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final db = ItemDatabase();

  List<Item> _items;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: db.fetchItems(),
      builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
        if (snapshot.hasData) {
          _items = snapshot.data;

          if (_items.isEmpty)
            return Center(child: Text("Puanlamak için 'Ekle'ye bas", style: TextStyle(fontSize: 32)));

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
            }
          );
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }
}

class ItemTile extends StatelessWidget {
  final Item _item;

  ItemTile(this._item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_item.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
      subtitle: Text("${_item.username}", style: TextStyle(fontSize: 16, color: Colors.black87),),
      leading: FutureBuilder(
        future: _item.instaPhoto,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
        style: TextStyle(fontSize: 21, color: Color.fromARGB(255, 252, 66, 123), fontWeight: FontWeight.w500, fontFamily: 'Duldolar'),
      ),

      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddPage.withItem(_item)
        ));
      }
    );
  }
}

