import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/core/utils/snack_bar_helper.dart';
import 'package:perfect/models/course_model.dart';

part 'my_libraby_state.dart';

class MyLibraryCubit extends Cubit<MyLibraryState> {
  MyLibraryCubit() : super(const MyLibraryState());
  final userId = FirebaseAuth.instance.currentUser?.uid;
  // Load user's purchased courses
  Future<void> loadMyCourses() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      if (userId == null) throw Exception("User not authenticated");

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final List<String> courseIds =
          List<String>.from(userDoc.data()?['myCourses'] ?? []);

      if (courseIds.isEmpty) {
        emit(state.copyWith(myCourses: [], loading: false));
        return;
      }

      final coursesSnap = await FirebaseFirestore.instance
          .collection('courses')
          .where(FieldPath.documentId, whereIn: courseIds)
          .get();

      final coursesWithVideosFutures =
          coursesSnap.docs.map((doc) => Course.fromDocumentWithVideos(doc));
      final coursesWithVideos = await Future.wait(coursesWithVideosFutures);

      emit(state.copyWith(myCourses: coursesWithVideos, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  void addToFavoritesCourses(
      String courseId, BuildContext ctx, ResponsiveConfig size) async {
    try {
      if (userId == null) throw Exception("User not authenticated");
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final userDoc = await userRef.get();
      if (userDoc.exists) {
        List<dynamic> favorites = userDoc.data()?['favorites'] ?? [];
        if (!favorites.contains(courseId)) {
          favorites.add(courseId);
          await userRef.update({'favorites': favorites});
        }
      } else {
        await userRef.set({
          'favorites': [courseId]
        }, SetOptions(merge: true));
      }
      showCustomSnackbar(
          context: ctx, message: 'COURSE ADDED TO FAVORITES', size: size,backgroundColor: PColors.success);
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

void toggleFavoriteCourse(String courseId,BuildContext ctx,ResponsiveConfig size) async {

  try {
    if (userId == null) throw Exception("User not authenticated");

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    final userDoc = await userRef.get();

    if (userDoc.exists) {
      List<dynamic> favorites = userDoc.data()?['favorites'] ?? [];

      if (favorites.contains(courseId)) {
        // remove
        favorites.remove(courseId);
          showCustomSnackbar(
              context: ctx, message: 'Removed from favorites', size: size,backgroundColor: PColors.primary,icon: Icons.heart_broken);
       
      } else {
        // add
        favorites.add(courseId);
                  showCustomSnackbar(
              context: ctx, message: 'Course added to favorites', size: size,backgroundColor: PColors.primary,icon: Icons.favorite);
      }

      await userRef.update({'favorites': favorites});
    } else {
      await userRef.set({'favorites': [courseId]}, SetOptions(merge: true));
    }

    // refresh favorites
    await loadFavoriteCourses();

  } catch (e) {
    emit(state.copyWith(loading: false, error: e.toString()));
  }
}


  // Load user's favorite courses
  Future<void> loadFavoriteCourses() async {
    
    try {
      if (userId == null) throw Exception("User not authenticated");

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final List<String> favoriteIds =
          List<String>.from(userDoc.data()?['favorites'] ?? []);

      if (favoriteIds.isEmpty) {
        emit(state.copyWith(favoriteCourses: []));
        return;
      }

      final favoritesSnap = await FirebaseFirestore.instance
          .collection('courses')
          .where(FieldPath.documentId, whereIn: favoriteIds)
          .get();

      final favoriteCoursesFutures =
          favoritesSnap.docs.map((doc) => Course.fromDocumentWithVideos(doc));

      final favoriteCoursesWithVideos =
          await Future.wait(favoriteCoursesFutures);

      emit(state.copyWith(
          favoriteCourses: favoriteCoursesWithVideos,));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }
}
