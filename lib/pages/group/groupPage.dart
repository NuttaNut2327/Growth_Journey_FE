import 'package:flutter/material.dart';
import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:hugeicons/hugeicons.dart';
import '/routes/app_routes.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const MainUpperNavBar(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Growing Together', 
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text('A small space for coming together\nand doing activities together.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8B7A99),
                            ),
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.createGroup);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Color(0xFFD8A7D9),
                          foregroundColor: Color(0xFFFFFFFF),
                        ),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedAdd01, 
                          size: 24,
                          strokeWidth: 2,
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ]
            )
          )
        )
      )
    );
  }
}