import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String name = "";
  String type;
  String mediaUrl;
  String mediaData;
  String owner;
  String ownerId; //For group posts

  double rate = 0;

  bool visibility = true;

  Timestamp timestamp;

  Post();
  Post.newPost(this.name, this.rate, this.mediaUrl);

  Post.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    type = map['type'];
    mediaUrl = map['url'];
    mediaData = map['mediaData'];
    rate = map['rate'];
    visibility = map['visibility'];
    owner = map['owner'];
    ownerId = map['ownerId'];
    timestamp = map['timestamp'];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'type': type,
    'url': mediaUrl,
    'mediaData': mediaData,
    'rate': rate,
    'visibility': visibility,
    'owner': owner,
    'ownerId': ownerId,
    'timestamp': timestamp
  };

}