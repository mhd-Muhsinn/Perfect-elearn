import 'package:flutter/material.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';

class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive =ResponsiveConfig(context);
    return Container(
      decoration: BoxDecoration(
      color: PColors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: PColors.primary
      )
      ),  
      width: responsive.percentWidth(.6),
      height: 50,
      child: Row(children: [
        Image.asset('assets/images/google_logo.png',width: 50,height: 60,),
        SizedBox(width: 10),
        Text('Continue With Google',style: TextStyle(fontWeight: FontWeight.w500))
      ],),
    );
  }
}