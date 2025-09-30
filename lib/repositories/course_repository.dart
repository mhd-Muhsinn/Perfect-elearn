// courses_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

  class CoursesRepository {
    final FirebaseFirestore  _firestore =FirebaseFirestore.instance;

    CoursesRepository();

    Stream<QuerySnapshot> getCoursesStream() {
      return _firestore
          .collection('courses')
          .orderBy('name')
          .snapshots();
    }
  }