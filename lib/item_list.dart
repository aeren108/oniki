import 'package:flutter/material.dart';

import 'add_page.dart';
import 'model/item.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<Item> _items;

  @override
  void initState() {
    //TODO: Fetch items from database (sqlite)
    super.initState();
    _items = Item.items;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int index) {
        Item item = _items[index];
        return Column(
          children: <Widget>[
            ItemTile(item),
            Divider(thickness: 1, indent: 8, endIndent: 8, color: Colors.black45,)
          ],
        );
      });
  }
}

class ItemTile extends StatelessWidget {
  Item _item;

  ItemTile(this._item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_item.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),),
      subtitle: Text("${_item.rateType} - ${_item.rate}/12", style: TextStyle(fontSize: 16, color: Colors.black87),),
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
         print("Selaamo");
         print("${_item.username}");
         return CircularProgressIndicator();
        }
      ),

      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddPage.withItem(_item)
        ));
      },
    );
  }
}

// child: CircleAvatar(
//          //TODO: Display instagram profile pictures for each item (NetworkImage(item.url))
//          backgroundImage: NetworkImage("https://avatars3.githubusercontent.com/u/27029242?s=460&v=4"),
//          radius: 28,
//        ),

