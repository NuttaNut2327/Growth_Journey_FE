import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/routes/app_routes.dart';

class MainUpperNavBar extends StatelessWidget {

  const MainUpperNavBar({super.key});

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Growth Journey',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  'Your growth journey',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF8B7A99)),
                ),
              ],
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
                Navigator.pushNamed(context, AppRoutes.profile);
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