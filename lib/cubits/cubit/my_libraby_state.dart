part of 'my_libraby_cubit.dart';


class MyLibraryState extends Equatable {
  final List<Course> myCourses;
  final List<Course> favoriteCourses;
  final bool loading;
  final String? error;

  const MyLibraryState({
    this.myCourses = const [],
    this.favoriteCourses = const [],
    this.loading = false,
    this.error,
  });

  MyLibraryState copyWith({
    List<Course>? myCourses,
    List<Course>? favoriteCourses,
    bool? loading,
    String? error,
  }) {
    return MyLibraryState(
      myCourses: myCourses ?? this.myCourses,
      favoriteCourses: favoriteCourses ?? this.favoriteCourses,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [myCourses, favoriteCourses, loading, error];
}

