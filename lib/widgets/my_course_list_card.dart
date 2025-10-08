import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/constants/image_strings.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/cubits/course_progress/course_progess_cubit.dart';
import 'package:perfect/cubits/course_progress/course_progress_state.dart';
import 'package:perfect/models/course_model.dart';
import 'package:shimmer/shimmer.dart';

class MyCourseListCard extends StatelessWidget {
  final String name;
  final String thumbnail;
  final String courseType;
  final String description;
  final Course course;
  VoidCallback menuOnTap;

  MyCourseListCard(
      {super.key,
      required this.name,
      required this.thumbnail,
      required this.description,
      required this.courseType,
      required this.course,
      required this.menuOnTap});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveConfig(context);

    return Card(
      elevation: 2,
      color: PColors.backgrndPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.percentWidth(0.02)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(responsive.percentWidth(0.02)),
                child: Container(
                  width: responsive.percentWidth(0.45),
                  height: responsive.percentWidth(0.28),
                  color: PColors.backgrndPrimary,
                  child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                 placeholder: PImages.placeholderimagewithbackgorund,
                image: thumbnail,
                imageErrorBuilder: (context, error, stackTrace) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: PColors.shimmerbasecolor,
                                highlightColor: PColors.shimmerhighlightcolor,
                                child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.white,
                                ),
                              ),
                              Image.asset(
                                PImages.placeholderimage,
                                height: 80,
                                width: 80,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        );
                }
                ),)
              ),

              SizedBox(width: responsive.percentWidth(0.04)),

              // Course details on right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.percentWidth(0.045),
                      ),
                    ),
                    SizedBox(height: responsive.percentWidth(0.04)),
                    Text(course.category),
                    Text(
                      course.language,
                      style: TextStyle(color: PColors.error),
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: menuOnTap, icon: Icon(Icons.menu)),
            ],
          ),
          Divider(),
          BlocBuilder<CourseProgressCubit, CourseProgressState>(
            builder: (context, state) {
              final progress = context
                  .read<CourseProgressCubit>()
                  .getProgressForCourse(course.id);
              return SizedBox(
                height: responsive.percentHeight(0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Progress :',style: TextStyle(fontWeight: FontWeight.bold),),
                
                    SizedBox(
                      width: responsive.percentWidth(0.56),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: PColors.iconPrimary,
                        color: PColors.containerBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Text("${(progress * 100).toStringAsFixed(0)}% ",
                        style:
                            TextStyle(fontSize: responsive.percentWidth(0.035),fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: responsive.percentWidth(0.02),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
