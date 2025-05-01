import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../widgets/custom_button.dart';

BlocBuilder textSection() {
  return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      if (state is AuthLoading) {
        return const CircularProgressIndicator();
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Welcome to ChatBot!",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "Sign in to continue",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          if (state is Unauthenticated) ...[
            Text(
              // "Oops! Something went wrong.\nPlease try again.",
              state.error,
              style: const TextStyle(
                  fontSize: 14, color: Colors.red, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
          CustomButton(
            iconPath: 'assets/logos/google.png',
            text: "Sign in with Google",
            onPressed: () {
              context.read<AuthBloc>().add(GoogleSignInRequested());
            },
            color: Colors.teal[900]!,
          ),
        ],
      );
    },
  );
}
