import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/blocs/chat/chat_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/core/utils/configs/resposive_config.dart';
import 'package:perfect/cubits/chat_with_admin/chat_with_admin_cubit.dart';
import 'package:perfect/screens/chat/chat_screen.dart';
import 'package:perfect/services/chat/chat_service.dart';
import 'package:perfect/widgets/chat_tile.dart';
import 'package:perfect/widgets/custom_app_bar.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveConfig size = ResponsiveConfig(context);
    context.read<ChatWithAdminCubit>().loadAdminUid();
    return BlocProvider(
      create: (_) => ChatBloc()..add(LoadTutorsEvent()),
      child: Scaffold(
          backgroundColor: PColors.backgrndPrimary,
          appBar:
              CustomAppBar(title: "Connect with us!", showBackButton: false),
          body: Column(
            children: [
              _buildAdminChat(size,context),
              _buildTutorsList(),
            ],
          )),
    );
  }

  Widget _buildTutorsList() {
    return Expanded(
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            if (state.tutors.isEmpty) {
              return const Center(child: Text("No tutors found."));
            }
            return ListView.builder(
              itemCount: state.tutors.length,
              itemBuilder: (context, index) {
                final tutor = state.tutors[index];
                return ChatTile(tutor: tutor);
              },
            );
          } else if (state is ChatError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox.shrink();
        },
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
                          tutorName: "Chat with us.")));
            }
          },
          child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
                border: Border.all(color: PColors.containerBackground)),
            child: Row(
              children: [
                Icon(Icons.message),
                SizedBox(width: size.percentWidth(0.04)),
                Text("Facing any issues? connect with uss..")
              ],
            ),
          ),
        );
      },
    );
  }
}
