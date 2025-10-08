import 'package:flutter/material.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:shimmer/shimmer.dart';

class CourseListCardShimmer extends StatelessWidget {
  const CourseListCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveConfig(context);

    return Card(
      elevation: 2,
      color: PColors.backgrndPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.percentWidth(0.02)),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: EdgeInsets.all(responsive.percentWidth(0.03)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail shimmer
              Container(
                width: responsive.percentWidth(0.45),
                height: responsive.percentWidth(0.28),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                      BorderRadius.circular(responsive.percentWidth(0.02)),
                ),
              ),

              SizedBox(width: responsive.percentWidth(0.04)),

              // Right-side shimmer (Text placeholders)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: responsive.percentHeight(0.01)),

                    // Course title placeholder
                    Container(
                      width: responsive.percentWidth(0.35),
                      height: responsive.percentHeight(0.02),
                      color: Colors.grey.shade300,
                    ),

                    SizedBox(height: responsive.percentHeight(0.015)),

                    // Price placeholder
                    Container(
                      width: responsive.percentWidth(0.20),
                      height: responsive.percentHeight(0.018),
                      color: Colors.grey.shade300,
                    ),

                    SizedBox(height: responsive.percentHeight(0.02)),

                    // Description line 1
                    Container(
                      width: double.infinity,
                      height: responsive.percentHeight(0.015),
                      color: Colors.grey.shade300,
                    ),

                    SizedBox(height: responsive.percentHeight(0.008)),

                    // Description line 2
                    Container(
                      width: responsive.percentWidth(0.55),
                      height: responsive.percentHeight(0.015),
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
