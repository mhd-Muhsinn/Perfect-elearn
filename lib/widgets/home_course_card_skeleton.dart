import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';

class HomeCourseCardSkeleton extends StatelessWidget {
  final ResponsiveConfig config;

  const HomeCourseCardSkeleton({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Shimmer.fromColors(
        baseColor: PColors.shimmerbasecolor,
        highlightColor: PColors.shimmerhighlightcolor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail placeholder
            Container(
              height: config.percentHeight(0.15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
              ),
            ),

            // Text placeholders
            Padding(
              padding: EdgeInsets.all(config.blocksizehorizontal * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course name placeholder
                  Container(
                    height: 14,
                    width: config.percentWidth(0.4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Price placeholder
                  Container(
                    height: 12,
                    width: config.percentWidth(0.25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category placeholder
                  Container(
                    height: 10,
                    width: config.percentWidth(0.3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
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
