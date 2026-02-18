import 'package:flutter/material.dart';
import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:fe/widgets/userLevelCard.dart';
import 'package:fe/widgets/dailyQuestCard.dart';
import 'package:fe/pages/heal/models/user_level_model.dart';
import 'package:fe/pages/heal/models/quest_model.dart';

  final user = UserLevel(
    imagePath: 'https://i.pinimg.com/736x/e7/a0/32/e7a0323ead05bb13a9ad1f78135b51c1.jpg',
    level: 5,
    userName: 'NuttaNut',
    userPoint: 1250,
    fullPoint: 1500,
  );

  final List<Quest> mockQuests = [
  Quest.fromMap({
    'questId':'8b4d8a92-3e4c-4a5e-9a1d-6a7b2f3c0d82',
    'title':'Deep Breathing',
    'description':'Practice 5 cycles of deep breathing (4-7-8 technique)',
    'point': 50,
    'period':'5',
    'status':'PENDING',
  }),
  Quest.fromMap({
    'questId':'1f7c3e5a-92b4-47d9-bd8a-2c1e6f9a0b45',
    'title':'Morning Gratitude',
    'description':'List 3 things you\'re grateful for today',
    'point': 50,
    'period':'5',
    'status':'PENDING',
  }),
  Quest.fromMap({
    'questId':'c4e0a2d1-5b6f-4a9c-8e3d-7f2b1c9d6a78',
    'title':'Mindful Walk',
    'description':'Take a 10-minute walk and notice 5 things you see',
    'point': 75,
    'period':'10',
    'status':'PENDING',
  }),
  Quest.fromMap({
    'questId':'5a1c9e7b-0d3f-4b62-91e8-6c2d7f4a3b44',
    'title':'Morning Gratitude',
    'description':'List 3 things you\'re grateful for today',
    'point': 50,
    'period':'5',
    'status':'PENDING',
  }),
  Quest.fromMap({
    'questId':'9d2f6b73-8a41-4cde-a5b0-3e7c2f1a4d98',
    'title':'Connect with Someoneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',
    'description':'Join one group within the application to complete the activity.',
    'point': 150,
    'period':'60',
    'status':'PENDING',
  })
  ];

class HealPage extends StatelessWidget {
  const HealPage({super.key,});

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
                    const Text('Boost positive energy', 
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
                    UserLevelCard(user: user),
                    const SizedBox(height: 16),
                    Text('Daily Quests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 16),
                    Column(
                      children: mockQuests
                          .map((quest) => [
                                DailyQuestCard(quest: quest),
                                const SizedBox(height: 16),
                              ])
                          .expand((e) => e)
                          .toList(),
                    ),
                  ],
                ),
              ),
            ]
          )
      )
    );
  }
}