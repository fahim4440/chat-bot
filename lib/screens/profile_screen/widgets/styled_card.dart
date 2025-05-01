import 'package:flutter/material.dart';

Container styledCard(Widget child) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          spreadRadius: 2,
        ),
      ],
    ),
    child: child,
  );
}
