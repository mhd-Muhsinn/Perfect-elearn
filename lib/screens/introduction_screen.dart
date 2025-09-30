import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:perfect/core/utils/introduction_pages.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      done: const Text("Done"),
      onDone: () {},
      rawPages: [
        
      ],
    );
  }
  
}