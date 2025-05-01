import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final bool isDestructive;
  final String? iconPath;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.isDestructive = false,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: iconPath != null
          ? Image.asset(
              iconPath!,
              width: 20,
              height: 20,
            )
          : const SizedBox.shrink(),
      label: Text(text),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade400;
            }
            if (states.contains(WidgetState.pressed)) {
              return (color).withValues(alpha: 0.5);
            }
            return color;
          },
        ),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        elevation: WidgetStateProperty.all(4.0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}