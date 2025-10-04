import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perfect/services/chat/chat_service.dart';

part 'chat_with_admin_state.dart';

class ChatWithAdminCubit extends Cubit<ChatWithAdminState> {
  final ChatService _chatService= ChatService();

  ChatWithAdminCubit() : super(ChatWithAdminInitial());

  Future<void> loadAdminUid() async {
    emit(ChatWithAdminLoading());
    try {
      final adminUid = await _chatService.getAdminUid();
      if (adminUid != null) {
        emit(ChatWithAdminLoaded(adminUid));
      } else {
        emit(const ChatWithAdminError("No admin found"));
      }
    } catch (e) {
      emit(ChatWithAdminError(e.toString()));
    }
  }
}