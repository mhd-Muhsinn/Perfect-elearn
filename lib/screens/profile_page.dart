import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:perfect/blocs/auth/auth_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/constants/image_strings.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/widgets/option_tile.dart';
import 'package:perfect/widgets/pop_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);
    return Scaffold(
      backgroundColor: PColors.backgrndPrimary,
      body: Column(
        children: [
          const SizedBox(height: 60),

          // Profile Image with Edit Icon
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              _buildProfileImage(),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PColors.white,
                  border: Border.all(color: Colors.teal, width: 2),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.image, color: Colors.teal),
              ),
            ],
          ),

          SizedBox(height: size.spacingSmall),

          // Name & Email
          const Text(
            "James S. Hernandez",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          SizedBox(height: size.spacingSmall),
          const Text(
            "hernandex.redial@gmail.ac.in",
            style: TextStyle(color: Colors.grey),
          ),

          SizedBox(height: size.spacingMedium),
          _buildSettingsOptions(context)
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
        radius: 50,
        backgroundColor: PColors.containerBackground,
        backgroundImage: NetworkImage(PImages.profileimage));
  }

  Widget _buildSettingsOptions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          color: PColors.backgrndPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PColors.grey)),
      child: Column(
        children: [
          ProfileOptionTile(
            icon: IconlyLight.profile,
            title: 'Edit Profile',
            onTap: () {},
          ),
          ProfileOptionTile(
            icon: IconlyLight.notification,
            title: 'Notifications',
            onTap: () {},
          ),
          ProfileOptionTile(
            icon: IconlyLight.show,
            title: 'Dark Mode',
            onTap: () {},
          ),
          ProfileOptionTile(
            icon: IconlyLight.shield_done,
            title: 'Terms & Conditions',
            onTap: () {},
          ),
          ProfileOptionTile(
            icon: IconlyLight.info_circle,
            title: 'Help Center',
            onTap: () {},
          ),
          ProfileOptionTile(
            icon: IconlyLight.logout,
            title: 'Logout',
            onTap: () {
              PopDialogs.showLogoutDialog(context, () {
                context.read<AuthBloc>().add(LogOutEvent());
              });
            },
          ),
        ],
      ),
    );
  }
}
