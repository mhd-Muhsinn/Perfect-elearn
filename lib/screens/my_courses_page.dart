import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/cubits/chat_with_admin/my_libraby_cubit.dart';
import 'package:perfect/screens/course_video_player_screen.dart';
import 'package:perfect/widgets/custom_app_bar.dart';
import 'package:perfect/widgets/my_course_list_card.dart';
import 'package:perfect/widgets/my_courses_page_bottom_sheet.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({super.key});

  @override
  Widget build(BuildContext ctx) {

    ctx.read<MyLibraryCubit>().loadMyCourses();
    final responsive = ResponsiveConfig(ctx);
    return Scaffold(
        backgroundColor: PColors.backgrndPrimary,
        appBar: CustomAppBar(title: 'My Courses'),
        body: _buildCourseListCardsSection(ctx, responsive));
  }

  _buildCourseListCardsSection(BuildContext ctx, ResponsiveConfig responsive) {
    return BlocBuilder<MyLibraryCubit, MyLibraryState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.percentWidth(0.03),
            vertical: responsive.percentHeight(0.02),
          ),
          child: ListView.builder(
            itemCount: state.myCourses.length,
            itemBuilder: (context, index) {
              final course = state.myCourses[index];
              return Container(
                margin: EdgeInsets.only(bottom: responsive.percentHeight(0.02)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CourseScreenWithVideo(course: course)));
                  },
                  child: MyCourseListCard(
                    name: course.name,
                    courseType: course.courseType,
                    thumbnail: course.thumbnail.trim(),
                    description: course.description,
                    course: course,
                    menuOnTap: () {
                      final isFavorite =
                          state.favoriteCourses.any((c) => c.id == course.id);
                      showCourseOptionsBottomSheet(
                        ctx,
                        isFavorite: isFavorite,
                        onToggleFavorite: () {
                          ctx
                              .read<MyLibraryCubit>()
                              .toggleFavoriteCourse(course.id,ctx,responsive);

                        },
                        onDeleteCourse: () {},
                        onViewCourse: () {},
                      );
                     
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
