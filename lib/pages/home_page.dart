import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/pages/global_add_page.dart';
import 'package:oniki/pages/groups_page.dart';
import 'package:oniki/pages/notifications_page.dart';
import 'package:oniki/pages/profile_page.dart';
import 'package:oniki/pages/requests_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  var _pages = <Widget>[GroupsPage(), RequestsPage(), GlobalAddPage(), NotificationsPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        unselectedItemColor: Colors.grey,
        elevation: 8.0,
        iconSize: bottomNavItemSize,
        fixedColor: Colors.black,
        onTap: (int index) => setState(() {_selectedPage = index;}),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.group), title: Container()),
          BottomNavigationBarItem(icon: Icon(Icons.thumbs_up_down), title: Container()),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, color: (_selectedPage == 2) ? Colors.black87 : watermelon , size: bottomNavItemSize * 1.3,), title: Container(),),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), title: Container()),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Container())
        ],
      ),
      body: IndexedStack(
        index: _selectedPage,
        children: _pages,
      )
    );
  }
}

