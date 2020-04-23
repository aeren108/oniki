import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  Icon icon;
  Stream stream;

  NotificationBadge({ @required this.icon, @required this.stream });

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
                  borderRadius: BorderRadius.circular(12.0)
              ),
              constraints: BoxConstraints(
                  minWidth: 17.0,
                  minHeight: 17.0
              ),
              child: Center(child: Text(snapshot.data.toString(), style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white))),
            ),
          ) : Container(width: 0, height: 0)
        ],
      ),
    );
  }
}
