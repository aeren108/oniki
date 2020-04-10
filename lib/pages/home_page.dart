import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  var _pages = <Widget>[Container(child: Text("Boş")), Container(child: Text("Boş")), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        fixedColor: watermelon,
        onTap: (int index) => setState(() {_selectedPage = index;}),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Feed', style: TextStyle())
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text("Gruplar", style: TextStyle())
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text("Profil", style: TextStyle())
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedPage,
        children: _pages,
      )
    );
  }
}
