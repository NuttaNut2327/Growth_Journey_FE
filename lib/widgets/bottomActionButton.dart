import 'package:flutter/material.dart';
import 'package:fe/widgets/mainButton.dart';

class BottomActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? child;

  const BottomActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 16, 40, 36),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: child ??
          SizedBox(
            height: 48,
            width: double.infinity,
            child: MainButton(
              text: text,
              onPressed: onPressed,
            ),
          ),
    );
  }
}
