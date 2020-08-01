import 'package:oniki/model/group.dart';

class User {
  String id;
  String name;
  String token;
  String photo = PHOTO_PLACEHOLDER;

  List<Group> groups = [];

  static const String PHOTO_PLACEHOLDER = 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

  User.newUser(this.name, this.id, this.token);

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    token = map['token'];
    photo = map['photo'];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'photo': photo,
    'token': token
  };
}