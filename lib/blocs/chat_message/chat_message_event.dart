part of 'chat_message_bloc.dart';

abstract class ChatMessageEvent {}

class SendMessageEvent extends ChatMessageEvent {
  final String tutorId;
  final String message;
  final String senderName;

  SendMessageEvent({
    required this.tutorId,
    required this.message,
    required this.senderName,
  });
}
// Load chat messages between two users
class LoadMessagesEvent extends ChatMessageEvent {
  final String otherUserId;

   LoadMessagesEvent(this.otherUserId);

  @override
  List<Object?> get props => [otherUserId];
}
