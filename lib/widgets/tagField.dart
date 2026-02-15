import 'package:flutter/material.dart';

class TagField extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TagField({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF5D7E3)
              : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: const Color(0xFFD8A7D9),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
