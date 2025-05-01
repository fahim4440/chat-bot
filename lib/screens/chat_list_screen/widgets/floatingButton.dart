import 'package:flutter/material.dart';

Widget floatingButton({required String aiName, required Color color, required Animation<double> animation, required Function navigateToChat}) {
  return ScaleTransition(
    scale: animation,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: FloatingActionButton(
        heroTag: aiName,
        backgroundColor: color,
        onPressed: () => navigateToChat(aiName),
        child: Image.asset("assets/avatars/$aiName.png", width: 24, height: 24),
      ),
    ),
  );
}
