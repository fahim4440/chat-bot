part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

class ChatInitial extends ChatState {
  final List<ChatMessage> messages;
  const ChatInitial(this.messages);

  @override
  List<Object?> get props => [messages];
}

class AILoading extends ChatState {
  final List<ChatMessage> messages;
  const AILoading(this.messages);

  @override
  List<Object?> get props => [messages];
}
