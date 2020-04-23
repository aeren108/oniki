import 'package:flutter/material.dart';
import 'package:oniki/services/user_service.dart';

class NotificationBadge extends StatelessWidget {
  Icon icon;
  Stream stream;

  NotificationBadge({ Key key, @required this.icon, @required this.stream }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) => Stack(
        children: <Widget>[
          icon,
          snapshot.data != 0 ? Positioned(
            top: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(7.0)
              ),
              constraints: BoxConstraints(
                  minWidth: 16.0,
                  minHeight: 16.0
              ),
              child: Center(child: Text(snapshot.data.toString(), style: TextStyle(color: Colors.white))),
            ),
          ) : Container(width: 0, height: 0)
        ],
      ),
    );
  }
}
