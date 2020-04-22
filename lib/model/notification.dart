import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oniki/model/user.dart';

class Notification {
  String id;
  String from;
  String name;
  String media;
  String mediaData;
  String desc;
  String fromName;

  num rate = 0;

  int _type;
  void set type(NotificationType type) => this._type = type.index;
  NotificationType get type => NotificationType.values[_type];

  bool replied = false;

  Timestamp timestamp;
  User fromUser;

  Notification({this.id, this.from, this.name, this.media, this.desc});

  Notification.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    from = data['from'];
    name = data['name'];
    media = data['media'];
    mediaData = data['mediaData'];
    desc = data['desc'];
    rate = data['rate'];
    _type = data['type'];
    fromName = data['fromName'];
    replied = data['replied'];
    timestamp = data['timestamp'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from'] = this.from;
    data['name'] = this.name;
    data['media'] = this.media;
    data['mediaData'] = this.mediaData;
    data['desc'] = this.desc;
    data['rate'] = this.rate;
    data['type'] = this._type;
    data['fromName'] = this.fromName;
    data['replied'] = this.replied;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

enum NotificationType {
  REPLY, REQUEST
}
