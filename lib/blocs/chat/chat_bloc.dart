import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/services/chat/chat_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService = ChatService();

  ChatBloc() : super(ChatInitial()) {
    on<LoadTutorsEvent>(_onLoadTutors);
  }

  Future<void> _onLoadTutors(
      LoadTutorsEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final tutors = await chatService.fetchTutors();
      emit(ChatLoaded(tutors));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
