import 'package:flutter/material.dart';
import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:hugeicons/hugeicons.dart';
import '/routes/app_routes.dart';
import 'package:fe/widgets/groupCard.dart';

final List<Map<String, dynamic>> mockGroups = [
  {
    'title': 'Support Circle',
    'imagePath': 'assets/images/support_circle.jpg',
    'description': 'A safe space to share and listen. We meet weekly to support each other.',
    'location': 'Wellness Center Room 3',
    'eventDate': '2026-02-10T09:30:45Z',
    'joinedMemberCount': 6,
    'targetMemberCount': 8,
    'tags': ['Mental Health', 'Group Talk'],
    'status': 'joined',
  },
  {
    'title': 'Morning Yoga Flow',
    'imagePath': 'assets/images/yoga_group.jpg',
    'description': 'Start your day with gentle yoga and mindful breathing.',
    'location': 'Community Hall',
    'eventDate': '2025-10-15T24:30:45Z',
    'joinedMemberCount': 10,
    'targetMemberCount': 15,
    'tags': ['Yoga', 'Wellness'],
    'status': 'not_joined',
  },
    {
    'title': 'Creative Art Therapy',
    'imagePath': 'assets/images/art_therapy.jpg',
    'description':
        'Express your feelings through art in a calm and supportive environment.',
    'location': 'Art Room B',
    'eventDate': '2025-12-23T12:45:45Z',
    'joinedMemberCount': 8,
    'targetMemberCount': 8,
    'tags': ['Art', 'Therapy', 'Creative'],
    'status': 'not_joined',
  },
];

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
                Column(
                  children: mockGroups.map((group) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GroupCard(
                        title: group['title'],
                        imagePath: group['imagePath'],
                        description: group['description'],
                        location: group['location'],
                        eventDate: group['eventDate'],
                        joinedMemberCount: group['joinedMemberCount'],
                        targetMemberCount: group['targetMemberCount'],
                        tags: List<String>.from(group['tags']),
                        status: group['status'],
                      ),
                    );
                  }).toList(),
                ),
              ]
            )
          )
        )
      )
    );
  }
}