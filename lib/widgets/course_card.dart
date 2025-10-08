// course_card.dart
import 'package:flutter/material.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/constants/image_strings.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/core/utils/text_cutoff_helper.dart';
import 'package:perfect/models/course_model.dart';
import 'package:shimmer/shimmer.dart';

class CourseListCard extends StatelessWidget {
  final String name;
  final String price;
  final String thumbnail;
  final String courseType;
  final String description;
  final Course course;

  const CourseListCard(
      {super.key,
      required this.name,
      required this.price,
      required this.thumbnail,
      required this.description,
      required this.courseType,
      required this.course
      });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(responsive.percentWidth(0.02)),
            child: Container(
              width: responsive.percentWidth(0.45),
              height: responsive.percentWidth(0.28),
              color: PColors.backgrndPrimary,
              child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                 placeholder: PImages.placeholderimagewithbackgorund,
                image: thumbnail,
              ),
            ),
          ),

          SizedBox(width: responsive.percentWidth(0.04)),

          // Course details on right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: responsive.percentHeight(0.02)),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.percentWidth(0.045),
                  ),
                ),
                SizedBox(height: responsive.percentHeight(0.005)),
                Text(
                  courseType != 'Free' ? '₹$price' : 'Free Course',
                  style: TextStyle(
                    fontSize: responsive.percentWidth(0.04),
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: responsive.percentHeight(0.01)),
                Text(
                  truncateWithEllipsis(15, description),
                  style: TextStyle(
                    fontSize: responsive.percentWidth(0.035),
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
