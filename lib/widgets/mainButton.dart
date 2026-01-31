import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MainButton({
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
        backgroundColor: Color(0xFFD8A7D9),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color( 0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
    );
  }
}