import 'package:oniki/model/group.dart';

class User {
  String id;
  String name;
  String photo = 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

  List<Group> groups = [];

  User.newUser(this.name, this.id);

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    photo = map['photo'];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'photo': photo,
  };
}