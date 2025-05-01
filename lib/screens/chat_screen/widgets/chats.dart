import 'package:flutter/material.dart';

import '../../../models/chat_message.dart';

ListView chats(List<ChatMessage> messages) {
  return ListView.builder(
    reverse: true,
    itemCount: messages.length,
    itemBuilder: (context, index) {
      final message = messages[messages.length - 1 - index];
      return Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.userMessage,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          message.aiResponse != ''
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                              "assets/avatars/${message.aiName}.png"),
                          radius: 16,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            message.aiResponse ?? '',
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    },
  );
}
