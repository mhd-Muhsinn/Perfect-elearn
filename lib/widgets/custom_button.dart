import 'package:flutter/material.dart';
import 'package:perfect/core/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      
      borderRadius: BorderRadius.circular(50),
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 280, 
        decoration: BoxDecoration(
          color: PColors.containerBackground,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            // Container(
            //   decoration: const BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.circle,
            //   ),
            //   padding: const EdgeInsets.all(6),
            //   child: const Icon(
            //     Icons.arrow_forward,
            //     size: 18,
            //     color: Colors.blueAccent,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
