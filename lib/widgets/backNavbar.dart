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
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Spacer(),
            IconButton(
              onPressed: () {
                print('Notification clicked');
              }, 
              icon: HugeIcon(
                icon:  HugeIcons.strokeRoundedNotification02, 
                size: 18,
                strokeWidth: 2,
              ),
            ),
            IconButton(
              onPressed: () {
                print('Profile clicked');
              }, 
              icon: HugeIcon(
                icon:  HugeIcons.strokeRoundedUser, 
                size: 18,
                strokeWidth: 2,
              ),
            )
          ],
        ),
      )
    );
  }
}