import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/userLevelCard.dart';
import '/routes/app_routes.dart';
import 'package:fe/pages/profile/repository/mood_repository.dart';
import 'package:fe/pages/profile/models/mood_model.dart';
import 'package:fe/widgets/moodCalendarCard.dart';
import 'package:fe/widgets/profileActivityCard.dart';
import 'package:fe/api/auth/getUserByID.dart';
import 'package:fe/interface/auth/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final MoodRepository repo = MoodRepository();

  Future<User>? _userFuture;
  List<Mood> moods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPageData();
    loadMoods();
  }

  Future<void> _initPageData() async {
    try {
      setState(() {
        _userFuture = getUserByID();
        // _questsFuture = _loadDailyQuests();
      });
    } catch (e) {
      debugPrint('Error initializing heal page: $e');
    }
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
                            if (_userFuture == null)
                              const Center(child: CircularProgressIndicator())
                            else
                              FutureBuilder<User>(
                                future: _userFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  } else if (snapshot.hasData) {
                                    return UserLevelCard(
                                      user: snapshot.data!, 
                                      showEditIcon: true, 
                                      onEdit: () {
                                        Navigator.pushNamed(context, AppRoutes.editProfile);
                                      }
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            const SizedBox(height: 24),
                            MoodCalendarCard(moods: moods, isLoading: isLoading),
                            const SizedBox(height: 24),
                            ProfileActivitiesCard(userId: '1'),
                          ]
                        )
                    )
                 )
             )
          )
    );
  }
}