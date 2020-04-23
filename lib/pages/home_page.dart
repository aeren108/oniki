import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/pages/global_add_page.dart';
import 'package:oniki/pages/groups_page.dart';
import 'package:oniki/pages/notifications_page.dart';
import 'package:oniki/pages/profile_page.dart';
import 'package:oniki/pages/requests_page.dart';
import 'package:oniki/widgets/notification_badge.dart';

class HomePage extends StatefulWidget {
  static int selectedPage = 0;
  static StreamController badgeStreamCtrl = StreamController.broadcast();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _pages = <Widget>[GroupsPage(), RequestsPage(), GlobalAddPage(), NotificationsPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: HomePage.selectedPage,
        unselectedItemColor: Colors.grey,
        elevation: 8.0,
        iconSize: bottomNavItemSize,
        fixedColor: Colors.black,
        onTap: (int index) => setState(() { HomePage.selectedPage = index; }),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.group), title: Container()),
          BottomNavigationBarItem(icon: Icon(Icons.thumbs_up_down), title: Container()),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, color: (HomePage.selectedPage == 2) ? Colors.black87 : watermelon , size: bottomNavItemSize * 1.3,), title: Container(),),
          BottomNavigationBarItem(icon: NotificationBadge(icon: Icon(Icons.notifications), stream: HomePage.badgeStreamCtrl.stream), title: Container()),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Container())
        ],
      ),
      body: IndexedStack(
        index: HomePage.selectedPage,
        children: _pages,
      )
    );
  }
}