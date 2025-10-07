class CourseProgressState {
  final Map<String, int> totalVideos; // courseId -> total video count
  final Map<String, List<String>> completedVideos; // courseId -> completed video ids
  final Map<String, String> courseNames; // courseId -> course name

  CourseProgressState({
    required this.totalVideos,
    required this.completedVideos,
    required this.courseNames,
  });

  CourseProgressState copyWith({
    Map<String, int>? totalVideos,
    Map<String, List<String>>? completedVideos,
    Map<String, String>? courseNames,
  }) {
    return CourseProgressState(
      totalVideos: totalVideos ?? this.totalVideos,
      completedVideos: completedVideos ?? this.completedVideos,
      courseNames: courseNames ?? this.courseNames,
    );
  }
}
