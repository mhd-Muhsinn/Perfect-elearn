import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final String msg;
  const MessageBox({
    super.key,
    required this.alignment, required this.msg,
  });

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: alignment,
        margin: EdgeInsets.only(right: 20,left: 20,top: 20),
        decoration: BoxDecoration(
          border: Border.all()
        ),
        child: Text(msg));
  }
}