part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}

class LoadChatHistory extends ChatEvent {
  final String aiName;
  const LoadChatHistory(this.aiName);

  @override
  List<Object?> get props => [aiName];
}

class CheckAPIKey extends ChatEvent {
  final String aiName;
  const CheckAPIKey({required this.aiName});
  @override
  List<Object?> get props => [aiName];
}

class SendMessage extends ChatEvent {
  final ChatMessage message;
  const SendMessage(this.message);

  @override
  List<Object?> get props => [message];
}
