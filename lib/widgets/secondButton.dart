import 'package:flutter/material.dart';

class SecondButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SecondButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21911200),
        ),
        backgroundColor: Color(0xFFFEF8FC),
        foregroundColor: Color(0xFFF6E8F5),
        side: const BorderSide(color: Color(0xFFF7EDF7), width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color( 0xFF4A4458),
          fontSize: 14,
        ),
      ),
    );
  }
}