part of 'chat_with_admin_cubit.dart';

abstract class ChatWithAdminState extends Equatable {
  const ChatWithAdminState();

  @override
  List<Object?> get props => [];
}

class ChatWithAdminInitial extends ChatWithAdminState {}

class ChatWithAdminLoading extends ChatWithAdminState {}

class ChatWithAdminLoaded extends ChatWithAdminState {
  final String adminUid;

  const ChatWithAdminLoaded(this.adminUid);

  @override
  List<Object?> get props => [adminUid];
}

class ChatWithAdminError extends ChatWithAdminState {
  final String message;

  const ChatWithAdminError(this.message);

  @override
  List<Object?> get props => [message];
}
