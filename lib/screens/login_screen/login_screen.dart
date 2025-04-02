import 'package:chat_bot/screens/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const CircularProgressIndicator();
            }
            if (state is Unauthenticated) {
              return const Text("Unauthenticated");
            }
            if (state is Authenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            }
            return CustomButton(
              text: "Sign in with Google",
              onPressed: () {
                context.read<AuthBloc>().add(GoogleSignInRequested());
              },
            );
          },
        ),
      ),
    );
  }
}
