import 'package:flutter/material.dart';

Padding styledText(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        children: [
          TextSpan(
              text: "$label ",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.teal[900])),
          TextSpan(text: value),
        ],
      ),
    ),
  );
}
