import 'dart:async';
import 'package:chat_bot/screens/chat_list_screen/chat_list_screen.dart';
import 'package:chat_bot/services/shared_prefs_services.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      SharedPrefsServices prefsServices = SharedPrefsServices();
      bool isLoggedIn = await prefsServices.getUserLoggedInfoFromSharedPrefs();
      String uid = await prefsServices.getUserUidFromSharedPrefs();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                isLoggedIn ? ChatListScreen(uid: uid,) : const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/lottie/splash_screen.json',
          width: 400,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
