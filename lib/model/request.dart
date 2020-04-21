import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oniki/model/user.dart';

class Request {
  String id;
  String name;
  String receiver;
  String receiverName;
  String media;
  String desc;

  bool replied = false;
  bool rejected = false;

  Timestamp timestamp;
  User receiverUser;

  Request({this.id, this.receiver, this.name, this.media, this.desc});

  Request.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    receiver = data['receiver'];
    name = data['name'];
    media = data['media'];
    desc = data['desc'];
    receiverName = data['receiverName'];
    replied = data['replied'];
    rejected = data['rejected'];
    timestamp = data['timestamp'];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'receiver': receiver,
    'name': name,
    'media': media,
    'desc': desc,
    'receiverName': receiverName,
    'replied': replied,
    'rejected': rejected,
    'timestamp': timestamp
  };
}