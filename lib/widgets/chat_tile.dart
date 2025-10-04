import 'package:flutter/material.dart';
import 'package:perfect/screens/chat/chat_screen.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.tutor,
  });

  final Map<String, dynamic> tutor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(tutor["photourl"]),
      ),
      title: Text(tutor["name"]),
      subtitle: Text(tutor["email"]),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              tutorId: tutor["id"],
              tutorName: tutor["name"],
            ),
          ),
        );
      },
    );
  }
}