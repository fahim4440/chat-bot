class ChatMessage {
  final String userMessage;
  final String? aiResponse;
  final String aiName;
  final DateTime timestamp;

  ChatMessage({required this.userMessage, this.aiResponse, required this.aiName, required this.timestamp});
}
