import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool isRequired;
  final Widget? prefixIcon;
  final String? Function(T?)? validator;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.isRequired = false,
    this.prefixIcon,
    this.validator, required TextEditingController controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ส่วน Label พร้อมดอกจันสีแดง (ถอดแบบมาจาก AppTextField)
        Row(
          children: [
            if (isRequired)
              const Text(
                '* ',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator:
              validator ??
              (isRequired
                  ? (val) => val == null ? 'Please select $label' : null
                  : null),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0x8009101D),
              fontWeight: FontWeight.w400,
            ),
            // ใช้ค่า Border และสีเดียวกับ AppTextField ของคุณ
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFEBD3EC),
                width: 1.25,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD8A7D9), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0x8009101D)),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }
}
