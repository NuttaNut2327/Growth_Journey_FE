import 'package:flutter/material.dart';
import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:fe/widgets/userLevelCard.dart';

class HealPage extends StatelessWidget {
  const HealPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const MainUpperNavBar(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Growth Journey', 
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Complete quests and earn emotional energy.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8B7A99),
                      ),
                    ),
                    const SizedBox(height: 16),
                    UserLevelCard(),
                    const SizedBox(height: 16),
                    Text('Daily Quests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ]
          )
      )
    );
  }
}