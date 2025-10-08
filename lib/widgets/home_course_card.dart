import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/constants/image_strings.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/models/course_model.dart';
import 'package:shimmer/shimmer.dart';

class HomeCourseCard extends StatelessWidget {
  final ResponsiveConfig config;
  final Course course;
  final VoidCallback onTap;

  const HomeCourseCard({
    super.key,
    required this.config,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: config.percentWidth(0.55),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child:FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                 placeholder: PImages.placeholderimagewithbackgorund,
                image: course.thumbnail,
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
                                  height: config.percentHeight(0.15),
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
                ),
            ),
            Padding(
              padding: EdgeInsets.all(config.blocksizehorizontal * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.courseType != "Free"
                        ? "₹${course.price}"
                        : "Free Course",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: PColors.primary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.category,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
