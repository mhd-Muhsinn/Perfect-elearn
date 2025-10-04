import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current logged-in user
  User? get currentUser => _auth.currentUser;

  String get currentUserId => currentUser?.uid ?? '';

  /// Fetch tutors for the current user based on purchased courses
  Future<List<Map<String, dynamic>>> fetchTutors() async {
    if (currentUserId.isEmpty) return [];

    final userDoc =
        await _firestore.collection("users").doc(currentUserId).get();
    final myCourses = List<String>.from(userDoc["myCourses"] ?? []);

    final List<Map<String, dynamic>> tutorsList = [];

    for (var courseId in myCourses) {
      final courseDoc =
          await _firestore.collection("courses").doc(courseId).get();

      if (!courseDoc.exists) continue;

      final courseTutors = List<String>.from(courseDoc["course_tutors"] ?? []);

      for (var tutorId in courseTutors) {
        if (tutorId.isNotEmpty) {
          final tutorDoc =
              await _firestore.collection("tutors").doc(tutorId).get();
          if (tutorDoc.exists) {
            tutorsList.add({
              "id": tutorDoc.id,
              "name": tutorDoc["name"] ?? '',
              "email": tutorDoc["email"] ?? '',
              "photourl":
                  tutorDoc["photourl"] ?? "https://via.placeholder.com/150",
            });
          }
        }
      }
    }

    return tutorsList;
  }

  Future<String?> getAdminUid() async {
    try {
      final snapshot = await _firestore.collection('admins').get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Send a chat message
  Future<void> sendMessage(
      String tutorId, String message, String senderName) async {
    final chatId = _getChatId(currentUserId, tutorId);

    await _firestore
        .collection("chat_rooms")
        .doc(chatId)
        .collection("messages")
        .add({
      "senderId": currentUserId,
      "senderName": senderName,
      "receiverId": tutorId,
      "message": message,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  /// Stream messages between current user and tutor
  Stream<QuerySnapshot> getMessages(String tutorId) {
    final chatId = _getChatId(currentUserId, tutorId);
    return _firestore
        .collection("chat_rooms")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  /// Generate unique chat ID between two users
  String _getChatId(String uid1, String uid2) {
    List<String> ids = [uid1, uid2];
    ids.sort();
    String chatRoomID = ids.join('_');
    return chatRoomID;
  }
}
