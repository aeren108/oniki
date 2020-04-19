import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/services/group_service.dart';

class UserService {
  static final UserService _instance = UserService._();
  static UserService get instance => _instance;

  static User _currentUser = null;

  static User get currentUser  => _currentUser;
  static set currentUser(User u) => _currentUser = u;

  UserService._();

  Future<User> createUser(String name, String id, [String photoUrl]) async {
    DocumentReference doc = userRef.document(id);
    User u = User.newUser(name, id);

    if (photoUrl != null)
      u.photo = photoUrl;

    await doc.setData(u.toMap());

    return u;
  }

  Future<User> findUser(String id) async {
    DocumentSnapshot snapshot = await userRef.document(id).get();
    if (snapshot.data != null)
      return User.fromMap(snapshot.data);
    return null;
  }

  Future<void> updateUser(User u) async {
    DocumentReference doc = userRef.document(u.id);
    await doc.setData(u.toMap());
  }

  Future<List<Post>> getPosts(User u) async {
    QuerySnapshot query = await postRef.document(u.id).collection('posts').getDocuments();

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
    return <Group>[ for (var doc in query.documents) await GroupService.instance.findGroup(doc.documentID) ];
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
}