import 'package:chat_bot/screens/login_screen/widgets/text_section.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Row landscapeScreen(BoxConstraints constraints) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Lottie.asset("assets/lottie/icon.json",
            width: constraints.maxWidth * 0.3),
      ),
      const VerticalDivider(thickness: 1, width: 40, color: Colors.grey),
      Expanded(child: textSection()),
    ],
  );
}
