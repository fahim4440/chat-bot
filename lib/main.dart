import 'package:chat_bot/blocs/chat/chat_bloc.dart';
import 'package:chat_bot/screens/chat_screen/chat_screen.dart';
import 'package:chat_bot/screens/splash_screen/splash_screen.dart';
import 'package:chat_bot/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'blocs/auth/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(AuthService()),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return const MaterialApp(home: ChatScreen());
          } else {
            return const MaterialApp(home: SplashScreen());
          }
        },
      ),
    );
  }
}