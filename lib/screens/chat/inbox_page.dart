import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/blocs/chat/chat_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/cubits/chat_with_admin/chat_with_admin_cubit.dart';
import 'package:perfect/screens/chat/chat_screen.dart';
import 'package:perfect/widgets/chat_tile.dart';
import 'package:perfect/widgets/custom_app_bar.dart';
import 'package:perfect/widgets/lottie/no_data.dart';
import 'package:shimmer/shimmer.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);
    context.read<ChatWithAdminCubit>().loadAdminUid();

    return Scaffold(
      backgroundColor: PColors.backgrndPrimary,
      appBar: CustomAppBar(title: "Connect with us!", showBackButton: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminChat(size, context),
          const SizedBox(height: 10),
          Expanded(child: _buildTutorsList(context)),
        ],
      ),
    );
  }

  Widget _buildAdminChat(ResponsiveConfig size, BuildContext context) {
    return BlocBuilder<ChatWithAdminCubit, ChatWithAdminState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state is ChatWithAdminLoaded) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    tutorId: state.adminUid,
                    tutorName: "Support Team",
                  ),
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: PColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: PColors.grey,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: PColors.lightprimary,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.support_agent,
                      color: PColors.containerBackground, size: 28),
                ),
                SizedBox(width: size.percentWidth(0.04)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Facing any issues?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Tap to chat with our support team",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTutorsList(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return ListView.builder(
            itemCount: 6,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Shimmer.fromColors(
                baseColor: PColors.shimmerbasecolor,
                highlightColor: PColors.shimmerhighlightcolor,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          );
        } else if (state is ChatLoaded) {
          if (state.tutors.isEmpty) {
            return const Center(child: Text("No tutors found."));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: state.tutors.length,
            itemBuilder: (context, index) {
              final tutor = state.tutors[index];
              return ChatTile(tutor: tutor);
            },
          );
        } else if (state is ChatError) {
          return NoData();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
