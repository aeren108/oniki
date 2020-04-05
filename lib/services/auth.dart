
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static const String EMAIL = "password";
  static const String GOOGLE = "google.com";

  Future<FirebaseUser> get currentUser async { return _auth.currentUser();}

  Future<FirebaseUser> signInWithEmail(String email, String password) async {
    return (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
  }

  Future<FirebaseUser> registerWithEmail(String email, String password) async {
    return (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return (await _auth.signInWithCredential(credential)).user;
  }

  void signOut() async {
    FirebaseUser user = await currentUser;

    if (user != null) {
      switch (user.providerId) {
        case EMAIL:
          _auth.signOut();
          break;
        case GOOGLE:
          _googleSignIn.signOut();
          _auth.signOut();
          break;
      }
    }
  }
}