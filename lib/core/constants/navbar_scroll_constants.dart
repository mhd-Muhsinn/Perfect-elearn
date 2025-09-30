import 'package:flutter/material.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';

double animatedPositionedLeftValue(int currentIndex, BuildContext context) {
  final responsive = ResponsiveConfig(context);
  switch (currentIndex) {
    case 0:
      return responsive.blocksizehorizontal * 5.2;
    case 1:
      return responsive.blocksizehorizontal * 23.9;
    case 2:
      return responsive.blocksizehorizontal * 42.9;
    case 3:
      return responsive.blocksizehorizontal * 61.6;
    case 4:
      return responsive.blocksizehorizontal * 80.3;
    default:
      return responsive.blocksizehorizontal * 5.2;
  }
}
