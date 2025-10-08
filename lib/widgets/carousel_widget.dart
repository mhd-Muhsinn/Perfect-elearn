import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/constants/image_strings.dart';
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
        // 🟡 LOADING / WAITING STATE
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 16 / 9,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            items: List.generate(3, (index) {
              return Builder(
                builder: (BuildContext context) {
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
                },
              );
            }),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading images"));
        }

        final imageUrls = snapshot.data ?? [];
        if (imageUrls.isEmpty) {
          return const Center(child: Text("No carousel images found."));
        }

        // 🟢 LOADED STATE
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
                    child: FadeInImage.assetNetwork(
                      placeholder: PImages.placeholderimagewithbackgorund,
                      image: url,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 400),
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
