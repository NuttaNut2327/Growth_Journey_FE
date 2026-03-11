import 'package:flutter/material.dart';
import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/routes/app_routes.dart';
import 'package:fe/widgets/moodLevelModal.dart';
import 'package:fe/pages/home/enum/emotions.dart';
import 'package:fe/api/mood/recordMood.dart';
import 'package:fe/api/mood/getMoodByDate.dart';
import 'package:fe/widgets/moodCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<Emotions, int> emotionLevels = {
    Emotions.CALM: 1,
    Emotions.HAPPY: 1,
    Emotions.TIRED: 1,
    Emotions.ANXIOUS: 1,
    Emotions.SAD: 1,
    Emotions.ANGRY: 1,
  };

  Emotions? selectedEmotion;
  int selectedLevel = 1;
  bool showRive = false;
  bool _isSubmittingMood = false;
  bool _isCheckingTodayMood = true;
  TodayMood? _todayMood;

  @override
  void initState() {
    super.initState();
    _loadTodayMood();
  }

  Future<void> _loadTodayMood() async {
    setState(() {
      _isCheckingTodayMood = true;
    });

    try {
      final todayMood = await getMoodByDate(DateTime.now());
      if (!mounted) return;

      setState(() {
        _todayMood = todayMood;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _todayMood = null;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isCheckingTodayMood = false;
      });
    }
  }

  String getRiveAsset() {
    if (selectedEmotion == null) return '';

    switch (selectedEmotion!) {
      case Emotions.CALM:
        return 'assets/animations/calm_level_$selectedLevel.riv';

      case Emotions.HAPPY:
        return 'assets/animations/happy_level_$selectedLevel.riv';

      case Emotions.TIRED:
        return 'assets/animations/tired_level_$selectedLevel.riv';

      case Emotions.ANXIOUS:
        return 'assets/animations/anxious_level_$selectedLevel.riv';

      case Emotions.SAD:
        return 'assets/animations/sad_level_$selectedLevel.riv';

      case Emotions.ANGRY:
        return 'assets/animations/angry_level_$selectedLevel.riv';
    }
  }

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
                Center(
                  child: MoodSection(
                    isCheckingTodayMood: _isCheckingTodayMood,
                    todayMood: _todayMood,
                    emotionButton: emotionButton,
                  ),
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
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
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
        ),
        const SizedBox(height: 16),
      ],
    )));
  }

  Widget emotionButton(Emotions emotion, double size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            final level = await showDialog<int>(
              context: context,
              builder: (context) {
                return MoodLevelModal(emotion: emotion);
              },
            );

            if (level != null) {
              if (_isSubmittingMood) return;

              setState(() {
                _isSubmittingMood = true;
              });

              try {
                await recordMood(
                  emotion: emotion,
                  intensity: level,
                );

                if (!mounted) return;

                setState(() {
                  emotionLevels[emotion] = level;
                  selectedEmotion = emotion;
                  selectedLevel = level;
                  showRive = true;
                  _todayMood = TodayMood(emotion: emotion, intensity: level);
                });

                await _loadTodayMood();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mood recorded successfully'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text(e.toString().replaceFirst('Exception: ', ''))),
                );
              } finally {
                if (!mounted) return;
                setState(() {
                  _isSubmittingMood = false;
                });
              }
            }
          },
          child: Image.asset(
            'assets/images/${emotion.name.toLowerCase()}_level_1.png',
            width: size,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          emotion.label[0].toUpperCase() + emotion.label.substring(1),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF8B7A99),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
