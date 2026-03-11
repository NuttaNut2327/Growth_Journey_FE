import 'package:flutter/material.dart';
import 'package:fe/pages/home/enum/emotions.dart';
import 'package:fe/api/mood/getMoodByDate.dart';

class MoodSection extends StatelessWidget {
  final bool isCheckingTodayMood;
  final TodayMood? todayMood;
  final Widget Function(Emotions emotion, double size) emotionButton;

  Color getEmotionColor(Emotions emotion) {
  switch (emotion) {
    case Emotions.CALM:
      return const Color(0xFF5FA17B); // เขียวมิ้นต์
    case Emotions.HAPPY:
      return const Color(0xFFEEB33F); // เหลือง
    case Emotions.TIRED:
      return const Color(0xFF8E849F); // ม่วง
    case Emotions.ANXIOUS:
      return const Color(0xFFEF924E); // ส้ม
    case Emotions.SAD:
      return const Color(0xFF6C9BAD); // น้ำเงิน
    case Emotions.ANGRY:
      return const Color(0xFFA24A4E); // แดง
  }
}

  const MoodSection({
    super.key,
    required this.isCheckingTodayMood,
    required this.todayMood,
    required this.emotionButton,
  });

  @override
  Widget build(BuildContext context) {
    if (isCheckingTodayMood) {
      return const Center(child: CircularProgressIndicator());
    }

    if (todayMood != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${todayMood!.emotion.label[0].toUpperCase()}${todayMood!.emotion.label.substring(1)}',
            style: TextStyle(
              fontSize: 24,
              color: getEmotionColor(todayMood!.emotion),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Image.asset(
            'assets/images/${todayMood!.emotion.name.toLowerCase()}_level_${todayMood!.intensity}.png',
            width: 250,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox(width: 250, height: 250),
          ),
          const SizedBox(height: 16),
          const Text(
            'You have recorded your mood today.\n'
            'Great job taking care of your mental health!\n'
            'Remember, ups and downs are normal.\n'
            'Take things one step at a time.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4C4456),
            ),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 24,
      crossAxisAlignment: WrapCrossAlignment.end,
      alignment: WrapAlignment.center,
      children: [
        emotionButton(Emotions.CALM, 96),
        emotionButton(Emotions.HAPPY, 110),
        emotionButton(Emotions.TIRED, 95),
        emotionButton(Emotions.ANXIOUS, 99),
        emotionButton(Emotions.SAD, 100),
        emotionButton(Emotions.ANGRY, 100),
      ],
    );
  }
}