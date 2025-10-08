// courses_list_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/cubits/chat_with_admin/course_list_cubit.dart';
import 'package:perfect/cubits/chat_with_admin/course_list_state.dart';
import 'package:perfect/repositories/course_repository.dart';
import 'package:perfect/screens/course_detail_page.dart';
import 'package:perfect/widgets/course_card.dart';
import 'package:perfect/widgets/course_list_card_shimmer.dart';
import 'package:perfect/widgets/lottie/no_data.dart';
import 'package:perfect/widgets/search_box.dart';

class CoursesListView extends StatelessWidget {
  const CoursesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => CoursesRepository(), child: CoursesListContent());
  }
}

class CoursesListContent extends StatelessWidget {
  const CoursesListContent({super.key});
  @override
  Widget build(BuildContext context) {
    context.read<CourseListCubit>().loadCourses();
    final responsive = ResponsiveConfig(context);
    return Scaffold(
      backgroundColor: PColors.backgrndPrimary,
      body: Column(
        children: [
          SearchBox(responsive: responsive),
          Expanded(
            child: BlocBuilder<CourseListCubit, CourseListState>(
              builder: (context, state) {
                if (state is CourseListLoading) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        const CourseListCardShimmer(),
                  );
                } else if (state is CourseListError) {
                  return NoData();
                } else if (state is CourseListLoaded) {
                  if (state.courses.isEmpty) {
                    return NoData();
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.percentWidth(0.03),
                      vertical: responsive.percentHeight(0.02),
                    ),
                    child: ListView.builder(
                      itemCount: state.courses.length,
                      itemBuilder: (context, index) {
                        final course = state.courses[index];
                        return Container(
                          margin: EdgeInsets.only(
                              bottom: responsive.percentHeight(0.02)),
                          child: InkWell(
                            onTap: () {},
                            child: GestureDetector(
                              onTap: () async {
                                final purchased =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetailsPage(
                                      course: course,
                                    ),
                                  ),
                                );
                                if (purchased == true) {
                                  context.read<CourseListCubit>().loadCourses();
                                }
                              },
                              child: CourseListCard(
                                name: course.name,
                                price: course.price,
                                courseType: course.courseType,
                                thumbnail: course.thumbnail.trim(),
                                description: course.description,
                                course: course,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
