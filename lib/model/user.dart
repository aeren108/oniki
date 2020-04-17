class User {
  String name, id;
  String photo = 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

  User._();

  User.newUser(this.name, this.id);

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    photo = map['photo'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
    };
  }
}