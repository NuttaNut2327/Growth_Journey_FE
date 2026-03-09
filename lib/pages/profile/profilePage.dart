import 'package:fe/pages/heal/models/user_level_model.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/userLevelCard.dart';
import '/routes/app_routes.dart';
import 'package:fe/pages/profile/repository/mood_repository.dart';
import 'package:fe/pages/profile/models/mood_model.dart';
import 'package:fe/widgets/moodCalendarCard.dart';
import 'package:fe/widgets/profileActivityCard.dart';

final user = UserLevel(
  imagePath:
      'https://i.pinimg.com/736x/e7/a0/32/e7a0323ead05bb13a9ad1f78135b51c1.jpg',
  level: 5,
  userName: 'NuttaNut',
  userPoint: 1250,
  fullPoint: 1500,
);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final MoodRepository repo = MoodRepository();

  List<Mood> moods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMoods();
  }

  Future<void> loadMoods() async {
    final data = await repo.get30DayMoodsMock();

    setState(() {
      moods = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User profile'),
          centerTitle: true,
          leading: IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              size: 24,
              strokeWidth: 2,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedSettings01,
                size: 20,
                strokeWidth: 2,
              ),
              onPressed: () {
                print('Edit profile clicked');
              },
            ),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          children: [
                            UserLevelCard(
                              user: user,
                              showEditIcon: true,
                              onEdit: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.editProfile);
                              },
                            ),
                            const SizedBox(height: 24),
                            MoodCalendarCard(moods: moods, isLoading: isLoading),
                            const SizedBox(height: 24),
                            ProfileActivitiesCard(),
                          ]
                        )
                    )
                 )
             )
          )
    );
  }
}