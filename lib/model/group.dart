import 'package:oniki/model/post.dart';
import 'package:oniki/model/user.dart';

class Group {
  String id;
  String name;
  String admin;

  List<User> members = [];
  List<Post> posts = [];
  List<Post> feed = [];

  Group.newGroup(this.id, this.name, this.admin);
  Group.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    admin = data['admin'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'admin': admin,
    };
  }

  bool operator ==(g) => g is Group && g.id == id;
}