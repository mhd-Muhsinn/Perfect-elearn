import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/cubits/chat_with_admin/course_list_state.dart';
import 'package:perfect/models/course_model.dart';
import 'package:perfect/repositories/course_repository.dart';

class CourseListCubit extends Cubit<CourseListState> {
  final CoursesRepository repository;
  List<Course> _allCourses = [];
  List<String> _purchasedCourseIds = [];

  //  New filter state variables
  String? _selectedCategory;
  String? _selectedSubcategory;
  String? _selectedSubSubcategory;
  String? _selectedLanguage;
  String? _selectedCourseType;
  String? _selectedSort; // "Price Low-High"

  CourseListCubit(this.repository) : super(CourseListLoading());


  Future<void> loadCourses() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(CourseListError('User not authenticated'));
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      _purchasedCourseIds =
          List<String>.from(userDoc.data()?['myCourses'] ?? []);
      await for (var snapshot in repository.getCoursesStream()) {
        final coursesFutures =
            snapshot.docs.map((doc) => Course.fromDocumentWithVideos(doc));
        final coursesWithVideos = await Future.wait(coursesFutures);

        _allCourses = coursesWithVideos
            .where((course) => !_purchasedCourseIds.contains(course.id))
            .toList();

        emit(CourseListLoaded(
          courses: _applyAllFilters(_allCourses),
          allCourses: _allCourses,
        ));
      }
    } catch (error) {
      emit(CourseListError(error.toString()));
    }
  }

  // Search filter
  void searchCourses(String query) {
    if (state is CourseListLoaded) {
      final s = state as CourseListLoaded;
      final filtered = _applyAllFilters(_allCourses)
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(s.copyWith(courses: filtered, searchQuery: query));
    }
  }

  // Sorting filter
  void applySort(String? sortType) {
    _selectedSort = sortType;
    if (state is CourseListLoaded) {
      final s = state as CourseListLoaded;
      final filtered = _applyAllFilters(_allCourses)
          .where(
              (c) => c.name.toLowerCase().contains(s.searchQuery.toLowerCase()))
          .toList();

      emit(s.copyWith(courses: filtered, selectedFilter: sortType));
    }
  }

  // Category/Subcategory/Sub-Subcategory/Language/CourseType filters
  void applyCategory(String? category) {
    _selectedCategory = category;
    print(_selectedCategory);
    _refreshFilters();
  }

  void applySubcategory(String? subcategory) {
    _selectedSubcategory = subcategory;
    _refreshFilters();
  }

  void applySubSubcategory(String? subSubcategory) {
    _selectedSubSubcategory = subSubcategory;
    _refreshFilters();
  }

  void applyLanguage(String? language) {
    _selectedLanguage = language;
    _refreshFilters();
  }

  void applyCourseType(String? type) {
    _selectedCourseType = type;
    _refreshFilters();
  }

  void refreshFilters() {
    _refreshFilters();
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedSubcategory = null;
    _selectedSubSubcategory = null;
    _selectedLanguage = null;
    _selectedCourseType = null;
    _selectedSort = null;
    _refreshFilters();
  }

  // 🔹 Central method to re-apply filters and update state
  void _refreshFilters() {
    if (state is CourseListLoaded) {
      final s = state as CourseListLoaded;
      final filtered = _applyAllFilters(_allCourses)
          .where(
              (c) => c.name.toLowerCase().contains(s.searchQuery.toLowerCase()))
          .toList();

      emit(s.copyWith(courses: filtered));
    }
  }

  // 🔹 Main filtering logic
  List<Course> _applyAllFilters(List<Course> list) {
    var filtered = list;

    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      filtered =
          filtered.where((c) => c.category == _selectedCategory).toList();
    }

    if (_selectedSubcategory != null && _selectedSubcategory!.isNotEmpty) {
      filtered =
          filtered.where((c) => c.subCategory == _selectedSubcategory).toList();
    }

    if (_selectedSubSubcategory != null &&
        _selectedSubSubcategory!.isNotEmpty) {
      filtered = filtered
          .where((c) => c.subSubCategories == _selectedSubSubcategory)
          .toList();
    }

    if (_selectedLanguage != null && _selectedLanguage!.isNotEmpty) {
      filtered =
          filtered.where((c) => c.language == _selectedLanguage).toList();
    }

    if (_selectedCourseType != null && _selectedCourseType!.isNotEmpty) {
      filtered =
          filtered.where((c) => c.courseType == _selectedCourseType).toList();
    }

    // // 🔹 Sorting logic
    // if (_selectedSort != null) {
    //   switch (_selectedSort) {
    //     case 'Price Low-High':
    //       filtered.sort((a, b) => a.price.compareTo(b.price));
    //       break;
    //     case 'Price High-Low':
    //       filtered.sort((a, b) => b.price.compareTo(a.price));
    //       break;
    //   }
    // }

    return filtered;
  }
}
