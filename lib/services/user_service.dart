import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/post.dart';
import 'package:oniki/model/user.dart';

class UserService {
  static final UserService _instance = UserService._();
  static UserService get instance => _instance;

  static User _currentUser = null;

  static User get currentUser  => _currentUser;

  static set currentUser(User u) => _currentUser = u;

  UserService._();

  Future<void> createUser(String name, String id) async {
    DocumentReference doc = userRef.document(id);
    User u = User.newUser(name, id);
    await doc.setData(u.toMap());
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

  Future<void> deletePost(User u, Post p) async {
    DocumentReference userPostRef = postRef.document(u.id).collection('posts').document(p.id);

    await userPostRef.delete();
  }

  //Following system is suspended
  Future<void> followUser(User u, User f) async {
    await followingRef.document(u.id).collection('following').document(f.id).setData({
      'id': f.id
    });

    await followerRef.document(f.id).collection('followers').document(u.id).setData({
      'id': u.id
    });

    //TODO: Handle follower and following count update
  }

  Future<void> unfollowUser(User u, User f) async {
    await followingRef.document(u.id).collection('following').document(f.id).delete();
    await followerRef.document(f.id).collection('followers').document(u.id).delete();

    //TODO: Handle follower and following count update
  }
}