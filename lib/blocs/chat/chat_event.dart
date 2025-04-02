part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}

class SendMessage extends ChatEvent {
  final String message;
  const SendMessage(this.message);

  @override
  List<Object?> get props => [message];
}
