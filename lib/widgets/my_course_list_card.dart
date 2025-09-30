import 'package:flutter/material.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/core/utils/text_cutoff_helper.dart';
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(responsive.percentWidth(0.02)),
            child: Container(
              width: responsive.percentWidth(0.45),
              height: responsive.percentWidth(0.28),
              color: PColors.backgrndPrimary,
              child: Image.network(
                thumbnail,
                fit: BoxFit.cover,
                // shimmer while loading
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(color: Colors.white),
                  );
                },
                // icon if error occurs
                errorBuilder: (context, error, stackTrace) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      color: Colors.white,
                      child: Icon(
                        Icons.image,
                        size: responsive.percentWidth(0.1),
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
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
          IconButton(
              onPressed: 
                menuOnTap,
              
              icon: Icon(Icons.menu))
        ],
      ),
    );
  }
}
