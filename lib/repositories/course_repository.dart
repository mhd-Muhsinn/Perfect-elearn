// courses_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoursesRepository {
  //repository for user to interact with courses collection , coursepgrogess section.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CoursesRepository();

  Stream<QuerySnapshot> getCoursesStream() {
    return _firestore.collection('courses').orderBy('name').snapshots();
  }

  //function to add video id to courseprogress map . it will mark each course how may videos has completed..
  Future<void> markVideoComplete(String courseId, String videoId) async {
    final userId = _auth.currentUser!.uid;
    final userDoc = await _firestore.collection('users').doc(userId).get();

    final data = userDoc.data() as Map<String, dynamic>? ?? {};
    final courseProgressMap = data.containsKey('courseProgress')
        ? Map<String, dynamic>.from(data['courseProgress'])
        : {};

    final courseProgress = courseProgressMap.map<String, List<String>>(
      (key, value) => MapEntry(key, List<String>.from(value ?? [])),
    );

    final completedVideos = courseProgress[courseId] ?? [];

    if (!completedVideos.contains(videoId)) {
      completedVideos.add(videoId);
      courseProgress[courseId] = completedVideos;

      await _firestore.collection('users').doc(userId).update({
        'courseProgress': courseProgress,
      });
    }
  }

  Future<void> addPurchasedCourse(String courseId) async {
    final userId = _auth.currentUser!.uid;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final data = userDoc.data() as Map<String, dynamic>? ?? {};
    final courseProgressMap = data.containsKey('courseProgress')
        ? Map<String, dynamic>.from(data['courseProgress'])
        : {};

    // Initialize progress for this course as empty list
    courseProgressMap[courseId] = [];

    await _firestore.collection('users').doc(userId).update({
      'courseProgress': courseProgressMap,
    });
  }

  //function to add purchase report sales report collection
  Future<void> addPurchaseToSalesReport(
      String courseName, String customerName, String amount) async {
    await _firestore
        .collection('course_sales_report')
        .doc('sales_history')
        .collection('individual_sale')
        .add({
      "name": courseName,
      "Customer": customerName,
      "amount": amount,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}
