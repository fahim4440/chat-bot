import 'package:bloc/bloc.dart';
import 'package:chat_bot/services/ai_services.dart';
import 'package:chat_bot/services/firebase_services.dart';
import 'package:chat_bot/services/shared_prefs_services.dart';
import 'package:equatable/equatable.dart';

import '../../models/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadChatHistory>((event, emit) async {
      emit(ChatLoading());
      final FirebaseServices services = FirebaseServices();
      final messages = await services.getChatHistory(event.aiName);
      emit(ChatLoaded(messages));
    });

    on<SendMessage>((event, emit) async {
      final FirebaseServices firebaseServices = FirebaseServices();
      final AiServices aiServices = AiServices();
      final currentState;
      if (state is ChatLoaded) {
        currentState = state as ChatLoaded;
      } else if (state is AILoading) {
        currentState = state as AILoading;
      } else {
        currentState = state as ErrorState;
      }
      final newMessages = List<ChatMessage>.from(currentState.messages);

      // Add user message
      newMessages.add(event.message);
      emit(ChatLoaded(newMessages));
      emit(AILoading(newMessages));

      // Get AI Response
      try {
        final response = await aiServices.getAIResponse(
            event.message.userMessage, event.message.aiName);
        ChatMessage newMessage = ChatMessage(
            userMessage: event.message.userMessage,
            aiResponse: response,
            aiName: event.message.aiName,
            timestamp: event.message.timestamp);
        newMessages.removeLast();
        newMessages.add(newMessage);

        // Save to Firestore
        firebaseServices.saveMessage(newMessage);

        // Add AI response
        emit(ChatLoaded(newMessages));
      } catch (e) {
        newMessages.removeLast();
        emit(ErrorState(messages: newMessages, errorMessage: e.toString()));
      }
    });

    on<CheckAPIKey>((event, emit) async {
      final SharedPrefsServices prefsServices = SharedPrefsServices();
      String key = '';
      if (event.aiName == 'ChatGPT') {
        key = await prefsServices.getApiKeyFromSharedPrefs('chatGPTKey');
      } else if (event.aiName == 'Grok AI') {
        key = await prefsServices.getApiKeyFromSharedPrefs('grokAIKey');
      } else if (event.aiName == 'Gemini AI') {
        key = await prefsServices.getApiKeyFromSharedPrefs('geminiAIKey');
      } else if (event.aiName == 'ChatBot') {
        key = 'vnsdjvbsfovn';
      }
      if (key == '') {
        emit(MissingApiKey());
      }
    });
  }
}
