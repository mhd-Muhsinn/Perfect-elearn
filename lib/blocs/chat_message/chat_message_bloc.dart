import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/services/chat/chat_service.dart';

part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  final ChatService chatService =ChatService();

  ChatMessageBloc() : super(ChatMessageInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<LoadMessagesEvent>((event, emit) async {
      emit(MessagesLoading());
      await emit.forEach<QuerySnapshot>(
        chatService.getMessages(event.otherUserId),
        onData: (snapshot) {
          final messages = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          return MessagesLoaded(messages);
        },
        onError: (err, _) => MessagesError(err.toString()),
      );
    });
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatMessageState> emit) async {
    try {
      await chatService.sendMessage(
          event.tutorId, event.message, event.senderName);
    } catch (e) {
      emit(ChatMessageError(e.toString()));
    }
  }
}
