class Group {
  String id;
  String name;
  String admin;

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
}