import 'package:flutter/material.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:fe/widgets/secondButton.dart';

class ConfirmLogoutModal extends StatefulWidget {
  const ConfirmLogoutModal({super.key});

  @override
  State<ConfirmLogoutModal> createState() => _ConfirmLogoutModalState();
}

class _ConfirmLogoutModalState extends State<ConfirmLogoutModal> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Are you sure you want to log out?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SecondButton(
                  text: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 32),
                MainButton(
                  text: "Log Out",
                  onPressed: () {
                    print('log out confirmed');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}