import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfect/blocs/chat/chat_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/cubits/chat_with_admin/course_list_cubit.dart';
import 'package:perfect/cubits/chat_with_admin/course_list_state.dart';
import 'package:perfect/cubits/course_progress/course_progess_cubit.dart';
import 'package:perfect/cubits/course_progress/course_progress_state.dart';
import 'package:perfect/cubits/user_cubit.dart/user_cubit.dart';
import 'package:perfect/repositories/course_repository.dart';
import 'package:perfect/screens/course_detail_page.dart';
import 'package:perfect/screens/my_courses_page.dart';
import 'package:perfect/screens/my_favorite_courses_page.dart';
import 'package:perfect/widgets/carousel_widget.dart';
import 'package:perfect/widgets/category_card.dart';
import 'package:perfect/widgets/home_course_card.dart';
import 'package:perfect/widgets/home_course_card_skeleton.dart';

class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CourseListCubit(context.read<CoursesRepository>())..loadCourses(),
      child: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveConfig(context);
    print(context.watch<UserCubit>().state?.name);
    context.read<CourseListCubit>().loadCourses();
    context.read<CourseProgressCubit>().triggerCourseProgress();
    context.read<ChatBloc>().add(LoadTutorsEvent());

    return Scaffold(
      backgroundColor: PColors.backgrndPrimary,
      appBar: _Appbar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: config.blocksizehorizontal * 3,
          vertical: config.spacingSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarousel(config),
            const SizedBox(height: 16),
            _buildProgressSection(),
            const SizedBox(height: 24),
            _buildMyCoursesAndFavorites(context),
            const SizedBox(height: 30),
            _buildCourseList(config),
            const SizedBox(height: 40),
            _buildQuizSection(config),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _Appbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        "Hi Muhsin 👋",
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () {},
            icon: Badge.count(
              count: 1,
              child: Icon(IconlyLight.notification, color: Colors.black87),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCarousel(ResponsiveConfig config) {
    return Column(
      children: [
        SizedBox(height: config.spacingSmall),
        const CarouselWidget(),
      ],
    );
  }

  Widget _buildMyCoursesAndFavorites(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyCoursesPage()),
            ),
            child: const CategoryCard(title: 'My Courses'),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyFavoriteCoursesPage()),
            ),
            child: const CategoryCard(title: 'Favorite Courses'),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseList(ResponsiveConfig config) {
    return BlocBuilder<CourseListCubit, CourseListState>(
      builder: (context, state) {
        if (state is CourseListLoading) {
          return SizedBox(
            height: config.percentHeight(0.25),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: config.spacingSmall),
                child: HomeCourseCardSkeleton(config: config),
              ),
            ),
          );
        } else if (state is CourseListError) {
          return SizedBox(
            height: config.percentHeight(0.25),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: config.spacingSmall),
                child: HomeCourseCardSkeleton(config: config),
              ),
            ),
          );
        } else if (state is CourseListLoaded) {
          final courses = state.courses.take(6).toList();
          if (courses.isEmpty) {
            return SizedBox(
              height: config.percentHeight(0.25),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(right: config.spacingSmall),
                  child: HomeCourseCardSkeleton(config: config),
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Recommended for You",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: config.percentHeight(0.3),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return HomeCourseCard(
                      config: config,
                      course: course,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseDetailsPage(course: course),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProgressSection() {
    return BlocBuilder<CourseProgressCubit, CourseProgressState>(
      builder: (context, state) {
        final courseIds = state.completedVideos.keys.toList();
        if (courseIds.isEmpty) {
          return const Text("No progress yet",
              style: TextStyle(color: Colors.grey));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Progress",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: courseIds.length,
                itemBuilder: (context, index) {
                  final courseId = courseIds[index];
                  final total = state.totalVideos[courseId] ?? 0;
                  final completed =
                      state.completedVideos[courseId]?.length ?? 0;
                  final percent = total == 0 ? 0.0 : completed / total;
                  final courseName = state.courseNames[courseId] ?? 'Unknown';

                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(courseName,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: percent,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(10),
                          color: PColors.primary,
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$completed of $total completed",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuizSection(ResponsiveConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Challenges",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _quizCard(
          config,
          icon: Icons.bar_chart_rounded,
          title: "DEVCLASH",
          subtitle: "Aptitude • 12 Questions",
        ),
        const SizedBox(height: 12),
        _quizCard(
          config,
          icon: Icons.code_rounded,
          title: "DSA Challenge",
          subtitle: "10 Questions • Data Structures",
        ),
      ],
    );
  }

  Widget _quizCard(ResponsiveConfig config,
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: config.blocksizehorizontal * 4,
          vertical: config.blocksizeveritical * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: PColors.primary.withOpacity(0.15),
            child: Icon(icon, color: PColors.primary, size: 26),
          ),
          SizedBox(width: config.blocksizehorizontal * 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[600]),
        ],
      ),
    );
  }
}
