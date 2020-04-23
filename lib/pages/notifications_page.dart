import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/notification.dart' as Notif;
import 'package:oniki/pages/home_page.dart';
import 'package:oniki/pages/notification_post_page.dart';
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
            HomePage.badgeStreamCtrl.sink.add(_notifs.length);

            if (_notifs.isEmpty)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Text("Bildirim yok", style: TextStyle(fontSize: 24))),
                IconButton(icon: Icon(Icons.refresh), iconSize: 36, onPressed: () { setState(() {}); },)
              ],
            );

            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: ListView.builder(
                itemCount: _notifs.length,
                itemBuilder: (context, index) {
                  Notif.Notification n = _notifs[index];

                  if (n.type == Notif.NotificationType.REPLY) {
                    return Column(
                      children: <Widget>[
                        Dismissible(
                          key: Key(n.id),
                          background: Container(
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                      Icons.delete_forever, color: Colors.white,
                                      size: 38)
                              ),
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          child: ReplyNotificationTile(notif: n),
                          onDismissed: (direction) {
                            _userService.deleteNotification(n);
                            setState(() {
                              _notifs.remove(n);
                            });
                          },
                        ),
                        Divider(thickness: 1.0, indent: 10.0, endIndent: 10.0)
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        Dismissible(
                          direction: DismissDirection.endToStart,
                          child: RequestNotificationTile(notif: n),
                          key: Key(n.id),
                          background: Container(
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.delete_forever,
                                      color: Colors.white, size: 38)
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            _userService.deleteNotification(n);
                            setState(() {
                              _notifs.remove(n);
                            });
                          },
                        ),
                        Divider(thickness: 1.0, indent: 10.0, endIndent: 10.0)
                      ]
                    );
                  }
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
          Flexible(
            child: AutoSizeText.rich(TextSpan(
              children: [
                TextSpan(
                  text: notif.fromName,
                  style: TextStyle(color: watermelon),
                  recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                    if (notif.fromUser == null)
                      return ProfilePage.fromUserID(id: notif.from);
                    else
                      return ProfilePage.withUser(user: notif.fromUser);
                  }))
                ),

                TextSpan(
                  text: " bunu puanlamanı istedi"
                )
              ]),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              maxLines: 1
            )
          ),
        ],
      ),

      subtitle: Text(notif.name, style: TextStyle(fontSize: 15)),
      leading: CircleAvatar(
        child: Image(image: NetworkImage(notif.media)),
        radius: 28
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPostPage(notif: notif)));
      },
    );
  }
}

class ReplyNotificationTile extends StatelessWidget {
  Notif.Notification notif;

  ReplyNotificationTile({ @required this.notif });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Flexible(
            child: AutoSizeText.rich(TextSpan(
              children: [
                TextSpan(
                  text: notif.fromName,
                  style: TextStyle(color: watermelon),
                  recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                    if (notif.fromUser == null)
                      return ProfilePage.fromUserID(id: notif.from);
                    else
                      return ProfilePage.withUser(user: notif.fromUser);
                  }))
                ),

                TextSpan(
                  text: " isteğini cevapladı"
                )
              ]),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              maxLines: 1
            )
          ),
        ],
      ),

      subtitle: Text(notif.name, style: TextStyle(fontSize: 15)),
      leading: CircleAvatar(
          child: Image(image: NetworkImage(notif.media)),
          radius: 28
      ),
      trailing: Text(notif.rate.floor().toString(),
        style: TextStyle(fontSize: 32, color: watermelon, fontFamily: "Faster One")
      ),
    );
  }
}


