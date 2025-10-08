import 'package:flutter/material.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/screens/chat/chat_screen.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.tutor,
  });

  final Map<String, dynamic> tutor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: PColors.backgrndPrimary,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage(tutor["photourl"]),
        ),
        title: Text(
          tutor["name"],
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          tutor["email"],
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.orange),
          onPressed: () {
            // TODO: implement audio call feature
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Audio call feature coming soon!"),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
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
      ),
    );
  }
}
