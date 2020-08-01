import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/model/notification.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/model/request.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/services/group_service.dart';

class UserService {
  static final UserService _instance = UserService._();
  static UserService get instance => _instance;

  static User _currentUser = null;

  static User get currentUser  => _currentUser;
  static set currentUser(User u) => _currentUser = u;

  Map<String, User> userMap = {};

  UserService._();

  Future<User> createUser(String name, String id, String token, [String photoUrl]) async {
    DocumentReference doc = userRef.document(id);
    User u = User.newUser(name, id, token);

    if (photoUrl != null)
      u.photo = photoUrl;

    await doc.setData(u.toMap());

    return u;
  }

  Future<User> findUser(String id) async {
    if (userMap[id] != null)
      return userMap[id];

    DocumentSnapshot snapshot = await userRef.document(id).get();
    if (snapshot.data != null) {
      return userMap[id] = User.fromMap(snapshot.data);
    }
    return null;
  }

  Future<void> updateUser(User u) async {
    DocumentReference doc = userRef.document(u.id);
    await doc.setData(u.toMap());
  }

  Future<List<Post>> getPosts(User u) async {
    QuerySnapshot query = await postRef.document(u.id).collection('posts').orderBy("timestamp", descending: true).getDocuments();

    var posts = <Post>[];
    for (DocumentSnapshot doc in query.documents) {
      if (doc != null)
        posts.add(Post.fromMap(doc.data));
    }

    return posts;
  }

  Future<void> createPost(Post p) async {
    CollectionReference userPostRef = postRef.document(currentUser.id).collection('posts');
    DocumentReference doc = userPostRef.document();

    String id = doc.documentID;
    p.id = id;

    await userPostRef.document(id).setData(p.toMap());
  }

  Future<void> updatePost(Post p) async {
    CollectionReference userPostRef = postRef.document(currentUser.id).collection('posts');
    await userPostRef.document(p.id).setData(p.toMap());
  }

  Future<void> deletePost(Post p) async {
    DocumentReference userPostRef = postRef.document(currentUser.id).collection('posts').document(p.id);

    await userPostRef.delete();
  }

  Future<List<Group>> getGroups() async {
    QuerySnapshot query = await userRef.document(currentUser.id).collection("groups").getDocuments();
    List<Group> groups = [ for (var doc in query.documents) await GroupService.instance.findGroup(doc.documentID) ];

    return groups;
  }

  Future<Group> joinGroup(String id) async {
    DocumentSnapshot groupSnapshot = await groupRef.document(id).get();
    DocumentReference userDoc = userRef.document(currentUser.id).collection("groups").document(id);

    if (groupSnapshot.data == null)
      return null;

    await groupSnapshot.reference.collection("members").document(currentUser.id).setData({'id': currentUser.id});
    await userDoc.setData({'id': id});

    return await GroupService.instance.findGroup(id);
  }

  Future<void> leaveGroup(Group g) async {
    await groupRef.document(g.id).collection("members").document(currentUser.id).delete();
    await userRef.document(currentUser.id).collection("groups").document(g.id).delete();

    groupRef.document(g.id).collection("posts").where("ownerId", isEqualTo: currentUser.id).getDocuments().then((snapshot) {
      for (var doc in snapshot.documents)
        doc.reference.delete();
    });
  }

  Future<void> makeRequest(Request r) async {
    DocumentReference doc = requestRef.document(currentUser.id).collection("requests").document();
    r.id = doc.documentID;

    Notification n = Notification(id: r.id, desc: r.desc, from: currentUser.id, name: r.name, media: r.media);
    n.timestamp = Timestamp.now();
    n.fromName = currentUser.name;
    n.mediaData = r.mediaData;
    n.rate = r.rate;
    n.type = NotificationType.REQUEST;

    await doc.setData(r.toMap());
    await requestRef.document(r.receiver).collection("notifications").document(r.id).setData(n.toMap());
  }

  Future<void> updateRequest(Request r) async {
    await requestRef.document(currentUser.id).collection("requests").document(r.id).setData(r.toMap());

    Notification n = Notification(id: r.id, desc: r.desc, from: currentUser.id, name: r.name, media: r.media);
    n.timestamp = Timestamp.now();
    n.fromName = currentUser.name;
    n.mediaData = r.mediaData;
    n.rate = r.rate;
    n.type = NotificationType.REQUEST;

    await requestRef.document(r.receiver).collection("notifications").document(r.id).setData(n.toMap());
  }

  Future<bool> replyRequest(Notification n) async {
    if (n.type == NotificationType.REPLY)
      return false;

    Post p = Post();

    Notification willBeSent = Notification(id: n.id, desc: n.desc, name: n.name, media: n.media, from: currentUser.id);
    willBeSent.type = NotificationType.REPLY;
    willBeSent.rate = n.rate;
    willBeSent.mediaData = n.mediaData;
    willBeSent.fromName = currentUser.name;
    willBeSent.timestamp = Timestamp.now();

    n.replied = true;

    p.id = n.id;
    p.name = n.name;
    p.mediaUrl = n.media;
    p.mediaData = n.mediaData;
    p.type = "NORMAL";
    p.rate = n.rate;
    p.visibility = true;
    p.owner = currentUser.name;
    p.ownerId = currentUser.id;
    p.timestamp = Timestamp.now();

    await requestRef.document(n.from).collection("notifications").document(n.id).setData(willBeSent.toMap());
    await requestRef.document(n.from).collection("requests").document(n.id).delete();
    await requestRef.document(currentUser.id).collection("notifications").document(n.id).updateData({'replied': true});
    await updatePost(p);

    return true;
  }

  Future<List<Request>> getRequests() async {
    QuerySnapshot query = await requestRef.document(currentUser.id).collection("requests").orderBy("timestamp", descending: true).getDocuments();
    List<Request> requests = [];

    for (var doc in query.documents) {
      Request r = Request.fromMap(doc.data);
      findUser(r.receiver).then((user) => r.receiverUser = user);

      requests.add(r);
    }

    return requests;
  }

  Future<List<Notification>> getNotifications() async {
    QuerySnapshot query = await requestRef.document(currentUser.id)
        .collection("notifications").orderBy("timestamp", descending: true)
        .getDocuments();

    List<Notification> notifs = [];

    for (var doc in query.documents) {
      Notification n = Notification.fromMap(doc.data);
      findUser(n.from).then((user) => n.fromUser = user);

      notifs.add(n);
    }

    return notifs;
  }

  void deleteNotification(Notification n) {
    requestRef.document(currentUser.id).collection("notifications").document(n.id).delete();

    if (!n.replied && n.type == NotificationType.REQUEST)
      requestRef.document(n.from).collection("requests").document(n.id).updateData({'rejected': true});
  }

  deleteRequest(Request r) {
    requestRef.document(currentUser.id).collection("requests").document(r.id).delete();
    requestRef.document(r.receiver).collection("notifications").document(r.id).delete();
  }
}