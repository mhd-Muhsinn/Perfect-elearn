import 'package:flutter/material.dart';

void showCourseOptionsBottomSheet(
  BuildContext context, {
  required bool isFavorite,
  required VoidCallback onToggleFavorite,
  required VoidCallback onDeleteCourse,
  required VoidCallback onViewCourse,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            ListTile(
              leading: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              title: Text(isFavorite ? "Remove from Favorites" : "Add to Favorites"),
              onTap: () {
                Navigator.pop(context);
                onToggleFavorite();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.grey),
              title: const Text("Delete Course"),
              onTap: () {
                Navigator.pop(context);
                onDeleteCourse();
              },
            ),
            ListTile(
              leading: const Icon(Icons.play_circle_outline, color: Colors.blue),
              title: const Text("View Course"),
              onTap: () {
                Navigator.pop(context);
                onViewCourse();
              },
            ),
          ],
        ),
      );
    },
  );
}
