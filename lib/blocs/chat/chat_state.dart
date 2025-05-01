part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

class ChatInitial extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  const ChatLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class AILoading extends ChatState {
  final List<ChatMessage> messages;
  const AILoading(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ErrorState extends ChatState {
  final String errorMessage;
  final List<ChatMessage> messages;
  const ErrorState({required this.messages, required this.errorMessage});

  @override
  List<Object?> get props => [messages, errorMessage];
}

class MissingApiKey extends ChatState {
  @override
  List<Object?> get props => [];
}
