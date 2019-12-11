import 'package:flutter/material.dart';

import 'model/item.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<Item> items;

  @override
  void initState() {
    //TODO: Fetch items from database (sqlite)

    items = Item.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        Item item = items[index];

        return Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage("https://avatars3.githubusercontent.com/u/27029242?s=460&v=4"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(item.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(item.rateType.toLowerCase() + item.rate.toString() + "/12",
                      style: TextStyle(
                          fontSize: 17
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 2)
            ],
          ),
        );
      },
    );
  }
}
