import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/cubits/chat_with_admin/course_list_cubit.dart';
import 'package:perfect/cubits/chat_with_admin/course_list_state.dart';
import 'package:perfect/repositories/course_repository.dart';
import 'package:perfect/screens/course_detail_page.dart';
import 'package:perfect/screens/my_courses_page.dart';
import 'package:perfect/screens/my_favorite_courses_page.dart';
import 'package:perfect/widgets/carousel_widget.dart';
import 'package:perfect/widgets/category_card.dart';

class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CourseListCubit(context.read<CoursesRepository>())..loadCourses(),
      child: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    context.read<CourseListCubit>().loadcourse();
    final config = ResponsiveConfig(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _Appbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: config.blocksizehorizontal * 3,
          vertical: config.spacingSmall,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _builcarousel(config),
              SizedBox(height: config.spacingSmall),
              _buildenrolledandfavourites(context),
              SizedBox(height: config.spacingMedium),
              _buildCourseCard(config),
              SizedBox(height: config.spacingLarge),
              _buildquizSection(config),
              SizedBox(height: config.spacingLarge),
              SizedBox(
                height: config.spacingLarge,
              ),
              SizedBox(
                height: config.spacingLarge,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(ResponsiveConfig config) {
    return BlocBuilder<CourseListCubit, CourseListState>(
      builder: (context, state) {
        if (state is CourseListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CourseListError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is CourseListLoaded) {
          final courses = state.courses;
          if (courses.isEmpty) {
            return const Center(child: Text('No courses found'));
          }
          final displayCourses = courses.take(5).toList();

          return SizedBox(
            height: config.percentHeight(0.25),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayCourses.length,
              itemBuilder: (context, index) {
                final course = displayCourses[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: config.spacingSmall,
                  ),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CourseDetailsPage(course: course) ));
                    },
                    child: _courseCard(
                      config,
                      title: course.name,
                      price: '₹${course.price}',
                      thumbnailUrl: course.thumbnail,
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

 Row _buildenrolledandfavourites(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            child: CategoryCard(title: 'My Courses'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyCoursesPage()));
            },
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyFavoriteCoursesPage()));
                },
                child: CategoryCard(title: 'Favorite Courses'))),
      ],
    );
  }}

  Widget _courseCard(
    ResponsiveConfig config, {
    required String title,
    required String price,
    required String thumbnailUrl,
  }) {
    return Container(
      width: config.percentWidth(0.50),
      decoration: BoxDecoration(
        color: PColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: PColors.grey, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: thumbnailUrl.isNotEmpty
                ? Image.network(
                    thumbnailUrl,
                    height: config.percentHeight(0.15),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: config.percentHeight(0.15),
                    color: Colors.black12,
                    child: Icon(Icons.image, color: Colors.grey, size: 40),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(config.blocksizehorizontal * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(price,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: PColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _Appbar() {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text("Hi Muhsin..", style: GoogleFonts.acme()),
        actions: [
          IconButton(
              onPressed: () {},
              icon:
                  Badge.count(count: 1, child: Icon(IconlyLight.notification)))
        ]);
  }

  Widget _builcarousel(ResponsiveConfig size) {
    return Column(
      children: [SizedBox(height: size.spacingMedium), CarouselWidget()],
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
        color: PColors.backgrndPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: PColors.grey, blurRadius: 5, offset: Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: PColors.primary.withOpacity(0.1),
            child: Icon(icon, color: PColors.primary, size: 24),
          ),
          SizedBox(width: config.blocksizehorizontal * 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(fontSize: 12, color: PColors.grey)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: PColors.grey),
        ],
      ),
    );
  }

  Widget _buildquizSection(ResponsiveConfig config) {
    return Column(
      children: [
        //  Quiz Cards
        _quizCard(
          config,
          icon: Icons.bar_chart,
          title: "DEVCLASH",
          subtitle: "Aptitude • 12 Questions",
        ),
        SizedBox(height: config.spacingSmall),
        _quizCard(
          config,
          icon: Icons.functions,
          title: "xxys",
          subtitle: "DSA • 10 Questions",
        ),
      ],
    );
  }

