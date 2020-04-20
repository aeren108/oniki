class Request {
  String id, receiver, post, desc;
  bool replied = false;

  Request({this.id, this.receiver, this.post, this.desc});

  Request.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    receiver = data['receiver'];
    post = data['post'];
    desc = data['desc'];
    replied = data['replied'];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'receiver': receiver,
    'post': post,
    'desc': desc,
    'replied': replied
  };
}