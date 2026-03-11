import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class BackNavbar extends StatelessWidget {

  const BackNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                size: 24,
                strokeWidth: 2,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      )
    );
  }
}