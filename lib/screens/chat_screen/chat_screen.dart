import 'package:chat_bot/screens/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../widgets/banner_ad.dart';
import '../../widgets/interstitial_ad.dart';
import 'widgets/chats.dart';
import 'widgets/messageField.dart';

class ChatScreen extends StatefulWidget {
  final String aiName;

  const ChatScreen({super.key, required this.aiName});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late InterstitialAdWidget _interstitialAdWidget;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(CheckAPIKey(aiName: widget.aiName));
    context.read<ChatBloc>().add(LoadChatHistory(widget.aiName));
    _interstitialAdWidget = InterstitialAdWidget(
      adUnitId: 'ca-app-pub-7755526276291947/3530062762',
      onAdShown: () => Navigator.pop(context),
    );
  }

  @override
  void dispose() {
    _interstitialAdWidget.showAd();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/avatars/${widget.aiName}.png", width: 24, height: 24),
            const SizedBox(width: 10,),
            Text(widget.aiName),
          ],
        ),
        backgroundColor: Colors.teal[900],
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is MissingApiKey) {
            Future.delayed(Duration.zero, () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("API Key Required"),
                  content:
                      Text("Please add an API key in Profile Settings. To get api key please visit ${widget.aiName}'s website"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen())
                        );
                      },
                      child: const Text("Profile Settings"),
                    ),
                  ],
                ),
              );
            });
          }
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ChatLoaded) {
                    return chats(state.messages);
                  }
                  if (state is ErrorState) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    });
                    return chats(state.messages);
                  }
                  if (state is AILoading) {
                    return Stack(
                      children: [
                        chats(state.messages),
                        Center(
                            child: Lottie.asset("assets/lottie/typing.json",
                                width: 200)),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            messageField(
                context: context,
                controller: _controller,
                aiName: widget.aiName)
          ],
        ),
      ),
    );
  }
}
