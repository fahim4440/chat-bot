import 'package:chat_bot/screens/chat_list_screen/widgets/floatingButton.dart';
import 'package:chat_bot/screens/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/app_open_ad.dart';
import '../../widgets/banner_ad.dart';
import '../profile_screen/profile_screen.dart';

class ChatListScreen extends StatefulWidget {
  final String uid;
  const ChatListScreen({super.key, required this.uid});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin,WidgetsBindingObserver {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  late AppOpenAdWidget _appOpenAdWidget;
  bool _shouldShowAdOnResume = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _appOpenAdWidget = AppOpenAdWidget(
      adUnitId: 'ca-app-pub-7755526276291947/2463149836',
      onAdShown: () => debugPrint('App Open Ad dismissed'),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _shouldShowAdOnResume) {
      _appOpenAdWidget.showAd();
      _shouldShowAdOnResume = false; // Reset after showing
    }
  }

  void setShouldShowAdOnResume(bool value) {
    setState(() => _shouldShowAdOnResume = value);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _toggleFAB() {
    setState(() {
      isExpanded = !isExpanded;
      isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  void _navigateToChat(String aiName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(aiName: aiName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        foregroundColor: Colors.white,
        title: const Text("AI Chats"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.uid)
            .collection("chats")
            .orderBy("lastUpdated", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final chats = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final QueryDocumentSnapshot chat = chats[index];
              final String aiName = chat.id;
              final String lastMessage =
                  chat["lastMessage"] ?? "Start a conversation...";
              final Timestamp lastUpdated = chat["lastUpdated"];
              if (chats.isEmpty) {
                return const Center(
                  child: Text(
                    "Press + button to initiate chat",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/avatars/$aiName.png"), // AI Avatars
                  ),
                  title: Text(aiName),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        formatChatTimestamp(lastUpdated),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(aiName: aiName)),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isExpanded) ...[
            floatingButton(
                aiName: 'ChatGPT',
                animation: _animation,
                color: Colors.blue,
                navigateToChat: _navigateToChat),
            floatingButton(
                aiName: "Gemini AI",
                animation: _animation,
                color: Colors.white,
                navigateToChat: _navigateToChat),
            floatingButton(
                aiName: "Grok AI",
                animation: _animation,
                color: Colors.teal[900]!,
                navigateToChat: _navigateToChat),
            floatingButton(
                aiName: "ChatBot",
                animation: _animation,
                color: Colors.grey,
                navigateToChat: _navigateToChat),
          ],
          FloatingActionButton(
            onPressed: _toggleFAB,
            backgroundColor: Colors.black,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isExpanded
                  ? const Icon(Icons.close,
                      color: Colors.white, key: ValueKey(1))
                  : const Icon(Icons.add,
                      color: Colors.white, key: ValueKey(2)),
            ),
          ),
        ],
      ),
    );
  }

  String formatChatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      return "${date.hour % 12 == 0 ? 12 : date.hour % 12}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${date.day} ${_getMonthName(date.month)}";
    }
  }

  String _getMonthName(int month) {
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month];
  }
}
