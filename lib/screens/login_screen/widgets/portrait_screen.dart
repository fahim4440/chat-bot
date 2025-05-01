import 'package:chat_bot/screens/login_screen/widgets/text_section.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Column portraitScreen() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset("assets/lottie/icon.json", width: 250),
      const SizedBox(height: 20),
      textSection(),
    ],
  );
}
