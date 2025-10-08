import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:perfect/core/constants/image_strings.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Lottie.asset(
        PImages.noDatalottie
      ),
    );
  }
}