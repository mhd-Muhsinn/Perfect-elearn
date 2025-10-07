import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/repositories/auth_repository.dart';

import 'course_progress_state.dart';

class CourseProgressCubit extends Cubit<CourseProgressState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthRepository user = AuthRepository();

  CourseProgressCubit()
      : super(CourseProgressState(
          totalVideos: {},
          completedVideos: {},
          courseNames: {},
        )) {
    _listenCompletedVideos();
  }

  void _listenCompletedVideos() {
    print('Listening to completed videos...');
    String userId = user.getCurrentUserId();

    _firestore.collection('users').doc(userId).snapshots().listen((userDoc) {
      final data = userDoc.data() ?? {};
      final cpRaw = data['courseProgress'] ?? {};

      final cp = Map<String, List<String>>.fromEntries(
        (cpRaw as Map).entries.map(
          (e) {
            final raw = e.value;
            if (raw is List) {
              return MapEntry(e.key, List<String>.from(raw));
            } else if (raw is Map) {
              // handle old-style {0: "videoId"} map
              return MapEntry(
                  e.key, raw.values.map((v) => v.toString()).toList());
            } else {
              return MapEntry(e.key, []);
            }
          },
        ),
      );

      emit(state.copyWith(completedVideos: cp));
      _subscribeToVideoCountsAndNames(cp.keys.toList());
    });
  }

  void _subscribeToVideoCountsAndNames(List<String> courseIds) {
    for (var courseId in courseIds) {
      // 🔹 Listen for video count
      _firestore
          .collection('courses')
          .doc(courseId)
          .collection('videos')
          .snapshots()
          .listen((snapshot) {
        emit(state.copyWith(
          totalVideos: Map<String, int>.from(state.totalVideos)
            ..[courseId] = snapshot.docs.length,
        ));
      });

      // 🔹 Fetch and store course name once
      _firestore.collection('courses').doc(courseId).get().then((doc) {
        if (doc.exists) {
          final name = doc.data()?['name'] ?? 'Unknown Course';
          final updatedNames = Map<String, String>.from(state.courseNames)
            ..[courseId] = name;
          emit(state.copyWith(courseNames: updatedNames));
        }
      });
    }
  }
  double getProgressForCourse(String courseId) {
  final total = state.totalVideos[courseId] ?? 0;
  final completed = state.completedVideos[courseId]?.length ?? 0;
  if (total == 0) return 0;
  return completed / total;
 }

}