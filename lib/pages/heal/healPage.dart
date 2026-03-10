import 'package:fe/api/auth/getUserByID.dart';
import 'package:fe/api/quest/doQuest.dart';
import 'package:fe/api/quest/getDoneQuests.dart';
import 'package:fe/api/quest/getRandomQuests.dart';
import 'package:fe/interface/auth/user.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:fe/widgets/userLevelCard.dart';
import 'package:fe/widgets/dailyQuestCard.dart';
import 'package:fe/pages/heal/models/quest_model.dart';

class HealPage extends StatefulWidget {
  const HealPage({super.key});

  @override
  State<HealPage> createState() => _HealPageState();
}

class _HealPageState extends State<HealPage> {
  Future<User>? _userFuture;
  Future<List<Quest>>? _questsFuture;

  @override
  void initState() {
    super.initState();
    _initPageData();
  }

  Future<void> _initPageData() async {
    try {
      setState(() {
        _userFuture = getUserByID();
        _questsFuture = _loadDailyQuests();
      });
    } catch (e) {
      debugPrint('Error initializing heal page: $e');
    }
  }

  Future<List<Quest>> _loadDailyQuests() async {
    final randomQuests = await getRandomQuests();
    final doneQuests = await getDoneQuests();
    final doneQuestIds = doneQuests.map((quest) => quest.questId).toSet();

    return randomQuests.map((quest) {
      if (doneQuestIds.contains(quest.questId)) {
        return quest.copyWith(status: 'COMPLETED');
      }
      return quest;
    }).toList();
  }

  Future<void> _doQuestAndRefresh(String questId, Uint8List imageBytes) async {
    await doQuest(questId, imageBytes);
    if (!mounted) {
      return;
    }

    setState(() {
      _userFuture = getUserByID();
      _questsFuture = _loadDailyQuests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MainUpperNavBar(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Boost positive energy',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Complete quests and earn emotional energy.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF8B7A99)),
                  ),
                  const SizedBox(height: 16),

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
                          return UserLevelCard(user: snapshot.data!);
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                  const SizedBox(height: 16),
                  const Text(
                    'Daily Quests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),

                  if (_questsFuture == null)
                    const Center(child: CircularProgressIndicator())
                  else
                    FutureBuilder<List<Quest>>(
                      future: _questsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        final quests = snapshot.data ?? [];

                        if (quests.isEmpty) {
                          return const Center(
                            child: Text('No quests for today'),
                          );
                        }

                        return Column(
                          children: quests.map((quest) {
                            final isCompleted =
                                quest.status.toUpperCase() == 'COMPLETED';

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: DailyQuestCard(
                                quest: quest,
                                isCompleted: isCompleted,
                                onDoQuest: isCompleted
                                    ? null
                                    : (imageBytes) => _doQuestAndRefresh(
                                        quest.questId,
                                        imageBytes,
                                      ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
