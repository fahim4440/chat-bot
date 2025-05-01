import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/chat/chat_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'services/firebase_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
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
          create: (context) => AuthBloc(FirebaseServices()),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(FirebaseServices())..add(LoadProfileEvent()),
        ),
      ],
      child: const MaterialApp(home: SplashScreen()),
    );
  }
}