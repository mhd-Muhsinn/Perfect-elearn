import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:perfect/models/google_signin_result.dart';
import 'package:perfect/models/user_model.dart';
import 'package:perfect/services/firebase_operations.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseOperations _operations = FirebaseOperations();
  final GoogleSignIn _googleUser = GoogleSignIn();

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<User?> signUpUser(UserModel user) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email.toString(), password: user.password.toString());

    final _user = userCredential.user;
    if (_user != null) {
      _operations.setUser(user, _user.uid);
    }
    return _user;
  }

Future<User?> signInUser(String email, String password) async {
  final credential = await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  final uid = credential.user!.uid;

  // Check if user document exists in the 'users' collection
  final userDoc = await _operations.getUser(uid);

  if (!userDoc.exists) {
    await _auth.signOut();
    throw FirebaseAuthException(
      code: 'not-a-user',
      message: 'Access denied. You are not a student user.',
    );
  }

  return credential.user;
}


  Future<GoogleSignInResult?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleUser.signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) return null;

    final isExisting = await checkGooglenewUser(user);
    return GoogleSignInResult(user: user, isNew: !isExisting);
  }

  Future<bool> checkGooglenewUser(User? user) async {
    final userDoc = await _operations.getUser(user?.uid);
    if (userDoc.exists) {
      return true;
    } else {
      return false;
    }
  }
  Future<void> forgotPasswordemail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
  completeProfile(UserModel user,uid) async {
    _operations.setUser(user,uid);
  }

  signout() async {
    await _auth.signOut();
  }

  Future<void> googleSignOut() async {
    await _googleUser.signOut();
    await _auth.signOut();
  }
}
