import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/notification.dart' as Notif;
import 'package:oniki/pages/profile_page.dart';
import 'package:oniki/services/user_service.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _userService = UserService.instance;

  Future<List<Notif.Notification>> _future;
  List<Notif.Notification> _notifs = [];

  @override
  Widget build(BuildContext context) {
    _future = _userService.getNotifications();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Bildirimler", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: appBarGradient,
      ),

      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return _future = _userService.getNotifications();
        },
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if ((snapshot.connectionState != ConnectionState.done || !snapshot.hasData) && _notifs.isEmpty)
              return Center(child: CircularProgressIndicator());

            _notifs = snapshot.data;

            if (_notifs.isEmpty)
              return Center(child: Text("Bildirim yok", style: TextStyle(fontSize: 32)));

            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: ListView.builder(
                itemCount: _notifs.length,
                itemBuilder: (context, index) {
                  Notif.Notification n = _notifs[index];

                  if (n.type == Notif.NotificationType.REPLY)
                    return Column(
                      children: <Widget>[
                        ReplyNotificationTile(notif: n),
                        Divider(thickness: 1.0, indent: 10.0, endIndent: 10.0)
                      ],
                    );
                  else
                    return Column(
                      children: <Widget>[
                        RequestNotificationTile(notif: n),
                        Divider(thickness: 1.0, indent: 10.0, endIndent: 10.0)
                      ]
                    );
                }
              ),
            );
          },
        ),
      )
    );
  }
}

class RequestNotificationTile extends StatelessWidget {
  Notif.Notification notif;

  RequestNotificationTile({ @required this.notif });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          InkWell(
            child: Text(notif.fromName, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: watermelon)),
            onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage.fromUserID(id: notif.from))); },
          ),
          Text(" bunu puanlamanızı istedi", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ],
      ),
      subtitle: Text(notif.name, style: TextStyle(fontSize: 15)),
      leading: CircleAvatar(
        child: Image(image: NetworkImage(notif.media)),
        radius: 28
      ),
      onTap: () {
        //TODO: notification post page
      },
    );
  }
}

class ReplyNotificationTile extends StatelessWidget {
  Notif.Notification notif;

  ReplyNotificationTile({ @required this.notif });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


