import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Chat")),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatInitial) {
                  return chats(state.messages);
                }
                if (state is AILoading) {
                  return Stack(
                    children: [
                      chats(state.messages),
                      Center(child: Lottie.asset("assets/lottie/typing.json", width: 200)),
                    ],
                  );
                }
                return const Center(child: Text("Loading"));
              },
            ),
          ),
          _buildInputField(context),
        ],
      ),
    );
  }

  ListView chats(List<ChatMessage> messages) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        return Align(
          alignment: message.type == MessageType.user
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: message.type == MessageType.user
                  ? Colors.blueAccent
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.type == MessageType.user
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                context.read<ChatBloc>().add(SendMessage(_controller.text));
                _controller.clear();
              }
            },
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
