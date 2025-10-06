import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/services/carousel_serive.dart';
import 'package:shimmer/shimmer.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final service = CarouselService();
    final size = ResponsiveConfig(context);

    return StreamBuilder<List<String>>(
      stream: service.streamCarouselImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading images"));
        }

        final imageUrls = snapshot.data ?? [];

        if (imageUrls.isEmpty) {
          return const Center(child: Text("No carousel images found."));
        }

        return CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            aspectRatio: 16 / 9,
            autoPlayInterval: const Duration(seconds: 3),
          ),
          items: imageUrls.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: size.percentWidth(0.80),
                    child: Image.network(
                      url,
                      fit: BoxFit.fill,
                      // Show shimmer while loading
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: PColors.shimmerbasecolor ,
                            highlightColor: PColors.shimmerhighlightcolor,
                            child: Container(color: Colors.white),
                          );
                    
                     
                      },
                      // Show icon if error occurs
                      errorBuilder: (context, error, stackTrace) {
                        return Shimmer.fromColors(
                          baseColor: PColors.shimmerbasecolor,
                          highlightColor: PColors.shimmerhighlightcolor,
                          child: Container(
                            color: PColors.white,
                            child: Icon(
                              Icons.image,
                              size: size.percentWidth(0.20),
                              color: PColors.iconPrimary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
