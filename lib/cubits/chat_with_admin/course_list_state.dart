import 'package:perfect/models/course_model.dart';

abstract class CourseListState {}

class CourseListLoading extends CourseListState {}

class CourseListLoaded extends CourseListState {
  final List<Course> courses;       // filtered list
  final List<Course> allCourses;    // original list
  final String searchQuery;
  final String? selectedFilter;     // e.g., "Price" or "Category"

  CourseListLoaded({
    required this.courses,
    required this.allCourses,
    this.searchQuery = '',
    this.selectedFilter,
  });

  CourseListLoaded copyWith({
    List<Course>? courses,
    List<Course>? allCourses,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return CourseListLoaded(
      courses: courses ?? this.courses,
      allCourses: allCourses ?? this.allCourses,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class CourseListError extends CourseListState {
  final String message;
  CourseListError(this.message);
}

