import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perfect/models/user_model.dart';

class FirebaseOperations {
  final _firebase = FirebaseFirestore.instance;

  void setUser(UserModel user,dynamic uid) async{
  await  _firebase.collection("users").doc(uid).set({
      'uid': uid,
      'email': user.email,
      'name': user.name,
      'phone': user.Phonenumber,
      'createdAt': Timestamp.now()
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(dynamic uid) async {
    final userDoc = await _firebase.collection('users').doc(uid).get();
    return userDoc;
  }
}
