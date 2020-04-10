class Post {
  String id, name, type, mediaUrl, mediaData = "";
  double rate = 0;
  bool visibility = true;

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
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'type': type,
    'url': mediaUrl,
    'mediaData': mediaData,
    'rate': rate,
    'visibility': visibility
  };

}