import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/pages/profile/models/mood_model.dart';
import 'package:fe/pages/home/enum/emotions.dart';

class MoodCalendarCard extends StatelessWidget {
  final List<Mood> moods;
  final bool isLoading;

  const MoodCalendarCard({
    super.key,
    required this.moods,
    required this.isLoading,
  });

  Color getMoodColor(Emotions mood) {
    switch (mood) {
      case Emotions.HAPPY:
        return const Color(0xFFF7E4A6);
      case Emotions.CALM:
        return const Color(0xFFBFE5C9);
      case Emotions.SAD:
        return const Color(0xFFBFE3F7);
      case Emotions.ANXIOUS:
        return const Color(0xFFFFC88A);
      case Emotions.ANGRY:
        return const Color(0xFFF4A8A8);
      case Emotions.TIRED:
        return const Color(0xFFDCC9F5);
    }
  }

  Widget buildCalendar() {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: moods.map((mood) {
        int day = mood.recordedAt.day;

        return Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: getMoodColor(mood.moodType),
            shape: BoxShape.circle,
          ),
          child: Text(
            day.toString(),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
        );
      }).toList(),
    );
  }

  Widget legend(Emotions label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label.label[0].toUpperCase() + label.label.substring(1),
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF7EDF7),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              HugeIcon(
                icon: HugeIcons.strokeRoundedCalendar04,
                strokeWidth: 2,
                size: 20,
                color: Color(0xFFD8A7D9),
              ),
              SizedBox(width: 8),
              Text(
                "30 Day Mood Calendar",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Track your emotional journey over time",
            style: TextStyle(color: Color(0xFF8B7A99)),
          ),
          const SizedBox(height: 24),

          isLoading
              ? const Center(child: CircularProgressIndicator())
              : buildCalendar(),

          const SizedBox(height: 24),

          const Text(
            'Mood Legend :',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 4,
            childAspectRatio: 3,
            children: [
              legend(Emotions.HAPPY, const Color(0xFFFFEBB3)),
              legend(Emotions.CALM, const Color(0xFFC8E5D8)),
              legend(Emotions.TIRED, const Color(0xFFD4C8E5)),
              legend(Emotions.ANXIOUS, const Color(0xFFFFD4A3)),
              legend(Emotions.SAD, const Color(0xFFB8D4F1)),
              legend(Emotions.ANGRY, const Color(0xFFFFBBBD)),
            ],
          )
        ],
      ),
    );
  }
}