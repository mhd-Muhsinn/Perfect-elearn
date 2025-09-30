import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInResult {
  final User user;
  final bool isNew;

  GoogleSignInResult({required this.user, required this.isNew});
}
