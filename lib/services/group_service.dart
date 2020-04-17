import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/group.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/model/user.dart';
import 'package:oniki/services/user_service.dart';

class GroupService {
  static final GroupService _instance = GroupService._();
  static GroupService get instance => _instance;

  GroupService._();

  Future<Group> findGroup(String id) async {
    DocumentSnapshot doc = await groupRef.document(id).get();
    return Group.fromMap(doc.data);
  }

  Future<Group> createGroup(User u, String name) async {
    DocumentReference doc = groupRef.document();
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

    await groupRef.document(g.id).delete();
  }

  Future<List<Post>> getGroupPosts(Group g) async {
    QuerySnapshot query = await groupRef.document(g.id).collection("posts").getDocuments();
    return <Post>[ for (var doc in query.documents) Post.fromMap(doc.data) ];
  }

  Future<List<User>> getGroupMembers(Group g) async {
    QuerySnapshot query = await groupRef.document(g.id).collection("members").getDocuments();
    return <User>[ for (var doc in query.documents) await UserService.instance.findUser(doc.documentID) ];
  }
}