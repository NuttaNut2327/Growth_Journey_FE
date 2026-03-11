import 'package:flutter/material.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:fe/widgets/secondButton.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fe/routes/app_routes.dart';

class ConfirmLogoutModal extends StatefulWidget {
  const ConfirmLogoutModal({super.key});

  @override
  State<ConfirmLogoutModal> createState() => _ConfirmLogoutModalState();
}

class _ConfirmLogoutModalState extends State<ConfirmLogoutModal> {
  final _storage = const FlutterSecureStorage();
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await _storage.delete(key: 'token');
      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoggingOut = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

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
            const Text(
              'Log out',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Are you sure you want to log out?",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SecondButton(
                  text: "Cancel",
                  onPressed: () {
                    if (_isLoggingOut) return;
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 32),
                MainButton(
                  text: _isLoggingOut ? "Logging out..." : "Log Out",
                  onPressed: _isLoggingOut ? null : _handleLogout,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
