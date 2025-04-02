import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatInitial([])) {
    on<SendMessage>((event, emit) async {
      final currentState = state as ChatInitial;
      final newMessages = List<ChatMessage>.from(currentState.messages);

      // Add user message
      newMessages.add(ChatMessage(text: event.message, type: MessageType.user));
      emit(ChatInitial(newMessages));
      emit(AILoading(newMessages));

      // Simulate AI response delay
      await Future.delayed(const Duration(seconds: 2));

      // Add AI response
      newMessages.add(ChatMessage(text: "This is an AI response.", type: MessageType.ai));
      emit(ChatInitial(newMessages));
    });
  }
}
