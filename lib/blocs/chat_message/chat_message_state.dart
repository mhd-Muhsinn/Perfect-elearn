part of 'chat_message_bloc.dart';

abstract class ChatMessageState extends Equatable {}

class ChatMessageInitial extends ChatMessageState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MessageSent extends ChatMessageState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChatMessageError extends ChatMessageState {
  final String message;
  ChatMessageError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MessagesLoading extends ChatMessageState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MessagesLoaded extends ChatMessageState {
  final List<Map<String, dynamic>> messages;
  MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessagesError extends ChatMessageState {
  final String error;
  MessagesError(this.error);

  @override
  List<Object?> get props => [error];
}
