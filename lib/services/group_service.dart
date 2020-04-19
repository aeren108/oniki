import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/services/user_service.dart';
import 'package:shortid/shortid.dart';

class GroupService {
  static final GroupService _instance = GroupService._();
  static GroupService get instance => _instance;

  GroupService._();

  Future<Group> findGroup(String id) async {
    DocumentSnapshot doc = await groupRef.document(id).get();
    return Group.fromMap(doc.data);
  }

  Future<Group> createGroup(User u, String name) async {
    DocumentReference doc = groupRef.document(shortid.generate());
    Group g = Group.newGroup(doc.documentID, name, u.id);

    DocumentReference userDoc = userRef.document(u.id).collection("groups").document(g.id);
    DocumentReference memberDoc = groupRef.document(g.id).collection("members").document(u.id);

    await userDoc.setData({'id': g.id});
    await doc.setData(g.toMap());
    await memberDoc.setData({'id': u.id});

    return g;
  }

  Future<void> deleteGroup(Group g) async {
    List<User> members = await getGroupMembers(g);

    for (var user in members) {
      await userRef.document(user.id).collection("groups").document(g.id).delete();
    }

    groupRef.document(g.id).collection("posts").getDocuments().then((snapshot) {
      for (var doc in snapshot.documents)
        doc.reference.delete();
    });

    groupRef.document(g.id).collection("members").getDocuments().then((snapshot) {
      for (var doc in snapshot.documents)
        doc.reference.delete();
    });

    await groupRef.document(g.id).delete();
  }

  Future<Post> createPost(Group g, Post p) async {
    DocumentReference doc = groupRef.document(g.id).collection("posts").document();
    p.id = doc.documentID;

    await doc.setData(p.toMap());

    return p;
  }

  Future<void> updatePost(Group g, Post p) async {
    DocumentReference doc = groupRef.document(g.id).collection("posts").document(p.id);

    await doc.setData(p.toMap());
  }

  Future<void> deletePost(Group g, Post p) async {
    await groupRef.document(g.id).collection("posts").document(p.id).delete();
  }

  Future<List<Post>> getGroupFeed(Group g, [bool updateMembers = false]) async {
    List<Post> feed = [];

    if (g.members == null || g.members.isEmpty || updateMembers)
      await getGroupMembers(g);

    for (var user in g.members) {
      List<Post> userPosts = await UserService.instance.getPosts(user);
      feed.addAll(userPosts);
    }

    feed.removeWhere((post) => !post.visibility);
    feed.sort((a, b) => -a.timestamp.compareTo(b.timestamp));
    g.feed = feed;
    return feed;
  }

  Future<List<Post>> getGroupPosts(Group g) async {
    QuerySnapshot query = await groupRef.document(g.id).collection("posts").orderBy("timestamp", descending: true).getDocuments();
    g.posts = <Post>[ for (var doc in query.documents) Post.fromMap(doc.data) ];

    return g.posts;
  }

  Future<List<User>> getGroupMembers(Group g) async {
    QuerySnapshot query = await groupRef.document(g.id).collection("members").getDocuments();
    g.members = <User>[ for (var doc in query.documents) await UserService.instance.findUser(doc.documentID) ];

    return g.members;
  }
}