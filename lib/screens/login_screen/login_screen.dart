import 'package:chat_bot/screens/chat_list_screen/chat_list_screen.dart';
import 'package:chat_bot/screens/login_screen/widgets/landscape_screen.dart';
import 'package:chat_bot/screens/login_screen/widgets/portrait_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/banner_ad.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatListScreen(uid: state.user.uid),
              ),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isPortrait = constraints.maxWidth < 600;
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: isPortrait
                    ? portraitScreen()
                    : landscapeScreen(constraints),
              ),
            );
          },
        ),
      ),
    );
  }
}
