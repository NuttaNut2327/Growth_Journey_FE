import 'package:flutter/material.dart';
import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MainUpperNavBar(),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x33D8A7D9),
                      Color(0x33C8E5D8),
                      Colors.white,
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good to see you',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'How was your day, sunshine?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 24),
                      Wrap(
                        spacing: 28,
                        runSpacing: 24,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        alignment: WrapAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("calm_level_1");
                                },
                                child: Image.asset(
                                  'assets/images/calm_level_1.png',
                                  width: 87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Calm',
                                style: TextStyle(fontSize: 14, color: Color(0xFF8B7A99), fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("happy_level_1");
                                },
                                child: Image.asset(
                                  'assets/images/happy_level_1.png',
                                  width: 100,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Happy',
                                style: TextStyle(fontSize: 14, color: Color(0xFF8B7A99), fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("tired_level_1");
                                },
                                child: Image.asset(
                                  'assets/images/tired_level_1.png',
                                  width: 85,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tired',
                                style: TextStyle(fontSize: 14, color: Color(0xFF8B7A99), fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("anxious_level_1");
                                },
                                child: Image.asset(
                                  'assets/images/anxious_level_1.png',
                                  width: 89,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Anxious',
                                style: TextStyle(fontSize: 14, color: Color(0xFF8B7A99), fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("sad_level_1");
                                },
                                child: Image.asset(
                                  'assets/images/sad_level_1.png',
                                  width: 90,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Sad',
                                style: TextStyle(fontSize: 14, color: Color(0xFF8B7A99), fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("angry_level_1");
                                },
                                child: Image.asset(
                                  'assets/images/angry_level_1.png',
                                  width: 90,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Angry',
                                style: TextStyle(fontSize: 14, color: Color(0xFF8B7A99), fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFEEDFF1),
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedMonocle01, 
                            size: 20,
                            color: Color(0xFFD6A6D8),
                            strokeWidth: 2,
                          ), 
                          SizedBox(width: 8),
                          Text(
                            'Stress Test Questionnaire (ST5)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Complete a stress test questionnaire to evaluate your stress level.',
                        style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: MainButton(
                          text: "Start assessment", 
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.assessment);
                          },
                        )
                      ),
                    ],
                  ),
                )
              )
            ],
          )
        )
      );
  }
}
