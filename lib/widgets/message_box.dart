import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final String msg;
  final bool isSender;

  const MessageBox({
    super.key,
    required this.msg,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isSender ? Colors.orange.shade400 : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: isSender ? const Radius.circular(18) : const Radius.circular(4),
            bottomRight: isSender ? const Radius.circular(4) : const Radius.circular(18),
          ),
        ),
        child: Text(
          msg,
          style: TextStyle(
            color: isSender ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
