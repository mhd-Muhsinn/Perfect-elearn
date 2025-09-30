import 'package:flutter/material.dart';
import 'package:perfect/core/constants/colors.dart';

class PopDialogs {
 static Future<void> showLogoutDialog(
      BuildContext context, VoidCallback onConfirmLogout) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: PColors.backgrndPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title:
            const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",style: TextStyle(color: PColors.textPrimary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              onConfirmLogout(); // Perform logout logic
            },
            child: const Text("Logout",style: TextStyle(color: PColors.textWhite),),
          ),
        ],
      ),
    );
  }
}
