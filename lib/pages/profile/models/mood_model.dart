import 'package:fe/pages/home/enum/emotions.dart';

class Mood {
  final String userId;
  final Emotions moodType;
  final int intensity;
  final DateTime recordedAt;

  Mood({
    required this.userId,
    required this.moodType,
    required this.intensity,
    required this.recordedAt,
  });

  factory Mood.fromJson(Map<String, dynamic> json) {
    final moodRaw = (json['mood_type'] ?? '').toString().toLowerCase();

    return Mood(
      userId: (json['user_id'] ?? '').toString(),
      moodType: Emotions.values.firstWhere(
        (emotion) => emotion.label == moodRaw,
        orElse: () => Emotions.CALM,
      ),
      intensity: (json['intensity'] as num?)?.toInt() ?? 0,
      recordedAt: DateTime.tryParse((json['recorded_at'] ?? '').toString()) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'mood_type': moodType,
      'intensity': intensity,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }
}
