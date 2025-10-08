import 'package:flutter/material.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:shimmer/shimmer.dart';

class MyCourseListCardShimmer extends StatelessWidget {
  const MyCourseListCardShimmer({super.key});

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
          child: Column(
            children: [
              // Top section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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

                  // Right-side text placeholders
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course title
                        Container(
                          width: responsive.percentWidth(0.35),
                          height: responsive.percentHeight(0.02),
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: responsive.percentHeight(0.02)),

                        // Category
                        Container(
                          width: responsive.percentWidth(0.25),
                          height: responsive.percentHeight(0.018),
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: responsive.percentHeight(0.01)),

                        // Language
                        Container(
                          width: responsive.percentWidth(0.20),
                          height: responsive.percentHeight(0.018),
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),

                  // Menu icon shimmer
                  Container(
                    width: responsive.percentWidth(0.06),
                    height: responsive.percentWidth(0.06),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),

              SizedBox(height: responsive.percentHeight(0.015)),
              Divider(color: Colors.grey.shade300, thickness: 1),

              // Bottom progress bar section shimmer
              SizedBox(height: responsive.percentHeight(0.015)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // "Progress :" text placeholder
                  Container(
                    width: responsive.percentWidth(0.18),
                    height: responsive.percentHeight(0.02),
                    color: Colors.grey.shade300,
                  ),

                  // Linear progress bar placeholder
                  Container(
                    width: responsive.percentWidth(0.56),
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  // Percentage placeholder
                  Container(
                    width: responsive.percentWidth(0.10),
                    height: responsive.percentHeight(0.02),
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
              SizedBox(height: responsive.percentHeight(0.015)),
            ],
          ),
        ),
      ),
    );
  }
}
