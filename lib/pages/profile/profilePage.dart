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
import 'package:fe/widgets/confirmLogoutModal.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final MoodRepository repo = MoodRepository();

  Future<User>? _userFuture;
  int _activitiesRefreshKey = 0;
  List<Mood> moods = [];
  bool isLoading = true;
  String? moodError;

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
      });
    } catch (e) {
      debugPrint('Error initializing heal page: $e');
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _userFuture = getUserByID();
      _activitiesRefreshKey++;
    });
    await loadMoods();
    if (_userFuture != null) {
      await _userFuture!;
    }
  }

  Future<void> loadMoods() async {
    setState(() {
      isLoading = true;
      moodError = null;
    });

    try {
      final data = await repo.getMoodsInCurrentMonth();
      if (!mounted) return;

      setState(() {
        moods = data;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        moods = [];
        moodError = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User profile',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
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
              icon: HugeIcons.strokeRoundedLogout02,
              size: 20,
              strokeWidth: 2,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ConfirmLogoutModal(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                              onEdit: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  AppRoutes.editProfile,
                                );
                                if (result == true) {
                                  await _handleRefresh();
                                }
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    const SizedBox(height: 24),
                    MoodCalendarCard(
                      moods: moods,
                      isLoading: isLoading,
                      errorMessage: moodError,
                    ),
                    const SizedBox(height: 24),
                    ProfileActivitiesCard(
                      key: ValueKey(_activitiesRefreshKey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
