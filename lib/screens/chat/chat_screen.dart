import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/blocs/chat_message/chat_message_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/widgets/custom_app_bar.dart';
import 'package:perfect/widgets/custom_text_form_field.dart';
import 'package:perfect/widgets/message_box.dart';

class ChatScreen extends StatelessWidget {
  final String tutorId;
  final String tutorName;

  ChatScreen({
    super.key,
    required this.tutorId,
    required this.tutorName,
  });

  final TextEditingController _msgcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<ChatMessageBloc>().add(LoadMessagesEvent(tutorId));
    return Scaffold(
      backgroundColor: PColors.backgrndPrimary,
      appBar: CustomAppBar(
        title: tutorName,
      ),
      body: Column(
        children: [
          //fetchh messages..
          Expanded(child: _buildMessageList()),

          //inputbox
          _buildMessageBox(context)
        ],
      ),
    );
  }

  //all messages build widget
  Widget _buildMessageList() {
    return BlocBuilder<ChatMessageBloc, ChatMessageState>(
      builder: (context, state) {
        if (state is MessagesLoaded) {
          return ListView(
              children:
                  state.messages.map((msg) => _buildMessageItem(msg)).toList());
        }
        if (state is MessagesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MessagesError) {
          return Text("Error: ${state.error}");
        }
        return const Center(child: Text("No messages yet"));
      },
    );
  }

  //each messge item
  Widget _buildMessageItem(Map<String, dynamic> msg) {
    //message alignment
    bool isAdmin = msg["senderID"] == tutorId;
    var alignment = isAdmin ? Alignment.centerLeft : Alignment.centerRight;
    return MessageBox(alignment: alignment,msg: msg["message"],);
  }

  Widget _buildMessageBox(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: PColors.containerBackground)),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              hintText: "Type Something..",
              prefixIcon: Icons.message,
              controller: _msgcontroller,
            ),
          ),
          IconButton(
              onPressed: () {
                context.read<ChatMessageBloc>().add(SendMessageEvent(
                    tutorId: tutorId,
                    message: _msgcontroller.text,
                    senderName: tutorName));

                _msgcontroller.clear();
              },
              icon: Icon(
                Icons.send,
                color: PColors.containerBackground,
              ))
        ],
      ),
    );
  }
}


