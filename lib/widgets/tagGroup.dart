import 'package:flutter/material.dart';

class TagGroup extends StatelessWidget {
  final String label;
  const TagGroup({
    super.key,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0x80D8A7D9),
          width: 1,
        ),
      ),
      child: Text(
        label, 
        style: TextStyle(
          fontSize: 10
        ),
      ),
    );
  }
  
}