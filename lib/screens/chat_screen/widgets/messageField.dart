import 'package:chat_bot/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/chat/chat_bloc.dart';

Container messageField(
    {required BuildContext context,
    required TextEditingController controller,
    required String aiName}) {
  void sendMessage() {
    if (controller.text.isNotEmpty) {
      context.read<ChatBloc>().add(
            SendMessage(
              ChatMessage(
                userMessage: controller.text,
                aiName: aiName,
                timestamp: DateTime.now(),
              ),
            ),
          );
      controller.clear();
    }
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor, // Matches theme (light/dark)
      boxShadow: [
        BoxShadow(
          color: Colors.teal.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            maxLines: 6,
            minLines: 1,
            controller: controller,
            decoration: InputDecoration(
              hintText: "Type a message for $aiName...",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            textInputAction: TextInputAction.send,
            onSubmitted: (value) => sendMessage(), // Enter key triggers send
          ),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          onPressed: sendMessage,
          elevation: 2,
          backgroundColor: Colors.teal[900],
          mini: true, // Smaller FAB for compact look
          shape: const CircleBorder(), // Ensures circular shape
          child: const Icon(
            Icons.send,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    ),
  );
}
