import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oniki/model/user.dart';

class Request {
  String id;
  String name;
  String receiver;
  String receiverName;
  String media;
  String mediaData;
  String desc;

  num rate = 0;

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
    mediaData = data['mediaData'];
    desc = data['desc'];
    rate = data['rate'];
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
    'mediaData': mediaData,
    'desc': desc,
    'rate': rate,
    'receiverName': receiverName,
    'replied': replied,
    'rejected': rejected,
    'timestamp': timestamp
  };
}