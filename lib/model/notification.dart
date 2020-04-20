import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String id;
  String from;
  String post;
  String desc;

  int _type;
  void set type(NotificationType type) => this._type = type.index;
  NotificationType get type => NotificationType.values[_type];


  bool read = false;
  bool replied = false;

  Timestamp timestamp;

  Notification({this.id, this.from, this.post, this.desc});

  Notification.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    from = data['from'];
    post = data['post'];
    desc = data['desc'];
    _type = data['type'];
    read = data['read'];
    replied = data['replied'];
    timestamp = data['timestamp'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from'] = this.from;
    data['post'] = this.post;
    data['desc'] = this.desc;
    data['type'] = this._type;
    data['read'] = this.read;
    data['replied'] = this.replied;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

enum NotificationType {
  REPLY, REQUEST
}
