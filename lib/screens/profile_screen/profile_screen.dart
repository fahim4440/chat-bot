import 'package:chat_bot/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/profile/profile_bloc.dart';
import '../../widgets/banner_ad.dart';
import 'widgets/landscape_screen.dart';
import 'widgets/portrait_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController gptController = TextEditingController();
    final TextEditingController grokController = TextEditingController();
    final TextEditingController geminiController = TextEditingController();

    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: Colors.teal[900],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200], // Light grey background
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLogout) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  bool isPortrait = constraints.maxWidth < 600;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: isPortrait
                        ? portraitLayout(state, gptController, grokController,
                            geminiController, context)
                        : landscapeLayout(state, gptController, grokController,
                            geminiController, context),
                  );
                },
              );
            } else {
              return const Center(child: Text('Failed to load profile'));
            }
          },
        ),
      ),
    );
  }
}
