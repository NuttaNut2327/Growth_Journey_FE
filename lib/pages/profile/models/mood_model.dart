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
    return Mood(
      userId: json['user_id'],
      moodType: json['mood_type'],
      intensity: json['intensity'],
      recordedAt: DateTime.parse(json['recorded_at']),
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