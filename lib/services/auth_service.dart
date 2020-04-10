
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oniki/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final AuthService _instance = AuthService._();

  Future<FirebaseUser> get currentUser async { return _auth.currentUser();}
  static AuthService get instance => _instance;

  AuthService._() {
    _auth.onAuthStateChanged.listen((user) {
      UserService.instance.findUser(user.uid).then((user) {
        UserService.currentUser = user;
      });
    });
  }

  Future<FirebaseUser> signInWithEmail(String email, String password) async {
    return (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
  }

  Future<FirebaseUser> registerWithEmail(String email, String password) async {
    return (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
  }

  Future<GoogleSignInAccount> getGoogleAccount() async => await _googleSignIn.signIn();


  Future<FirebaseUser> authenticateWithGoogle(GoogleSignInAccount googleUser) async{
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return (await _auth.signInWithCredential(credential)).user;
  }

  Future<FirebaseUser> updateUser(UserUpdateInfo info) async {
    FirebaseUser user = await currentUser;
    await user.updateProfile(info);
    return user;
  }

  Future<void> signOut() async {
    FirebaseUser user = await currentUser;

    if (user != null) {
      _auth.signOut();
      _googleSignIn.signOut();
    }
  }
}