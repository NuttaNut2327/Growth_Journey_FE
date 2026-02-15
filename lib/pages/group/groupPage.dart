import 'package:flutter/material.dart';
import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:hugeicons/hugeicons.dart';
import '/routes/app_routes.dart';
import 'package:fe/widgets/groupCard.dart';
import 'package:fe/pages/group/modals/group_model.dart';

final List<Group> mockGroups = [
  Group.fromMap({
    'title': 'Support Circle',
    'imagePath': 'assets/images/support_circle.jpg',
    'description':
        'A safe and welcoming space where you can openly share your thoughts, experiences, and emotions without judgment. This weekly gathering encourages active listening, empathy, and mutual support among participants. Whether you want to speak or simply be present, you will find understanding, encouragement, and a sense of belonging within the circle.',
    'location': 'Wellness Center Room 3',
    'eventDate': '2026-02-10T09:30:45Z',
    'joinedMemberCount': 6,
    'targetMemberCount': 8,
    'tags': ['Mental Health', 'Group Talk'],
    'status': 'joined',
  }),
  Group.fromMap({
    'title': 'Morning Yoga Flow',
    'imagePath': 'assets/images/yoga_group.jpg',
    'description':
        'Begin your morning with a refreshing session of gentle yoga designed to awaken your body and calm your mind. Through guided stretches, breathing exercises, and mindful movement, this activity helps improve flexibility, reduce stress, and build positive energy for the day ahead. Suitable for all experience levels, including beginners.',
    'location': 'Community Hall',
    'eventDate': '2025-10-15T04:30:45Z',
    'joinedMemberCount': 10,
    'targetMemberCount': 15,
    'tags': ['Yoga', 'Wellness'],
    'status': 'not_joined',
  }),
  Group.fromMap({
    'title': 'Creative Art Therapy',
    'imagePath': 'assets/images/art_therapy.jpg',
    'description':
        'Explore your emotions and express your inner thoughts through creative art activities in a calm and supportive setting. Participants will experiment with colors, textures, and forms as a way to relax, reflect, and connect with themselves. No artistic background is required — this experience focuses on expression, healing, and enjoyment rather than perfection.',
    'location': 'Art Room B',
    'eventDate': '2025-12-23T12:45:45Z',
    'joinedMemberCount': 8,
    'targetMemberCount': 8,
    'tags': ['Art', 'Therapy', 'Creative'],
    'status': 'not_joined',
  }),
];

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.groupDetail, 
                          arguments: group,      
                        );
                      },
                      child: GroupCard(
                        title: group.title,
                        imagePath: group.imagePath,
                        description: group.description,
                        location: group.location,
                        eventDate: group.eventDate,
                        joinedMemberCount: group.joinedMemberCount,
                        targetMemberCount: group.targetMemberCount,
                        tags: group.tags,
                        status: group.status,
                      ),
                    )
                  );
                }).toList(),
              ),
            ]
          )
        )
      )
    );
  }
}