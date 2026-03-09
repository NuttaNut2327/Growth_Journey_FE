import 'package:fe/pages/profile/models/mood_model.dart';
import 'package:fe/pages/home/enum/emotions.dart';

class MoodRepository {
 final List<Mood> mockMoods = [
  Mood(userId: "1", moodType: Emotions.HAPPY, intensity: 5, recordedAt: DateTime(2026,3,1)),
  Mood(userId: "1", moodType: Emotions.CALM, intensity: 4, recordedAt: DateTime(2026,3,2)),
  Mood(userId: "1", moodType: Emotions.SAD, intensity: 3, recordedAt: DateTime(2026,3,3)),
  Mood(userId: "1", moodType: Emotions.ANXIOUS, intensity: 4, recordedAt: DateTime(2026,3,4)),
  Mood(userId: "1", moodType: Emotions.TIRED, intensity: 2, recordedAt: DateTime(2026,3,5)),
  Mood(userId: "1", moodType: Emotions.CALM, intensity: 4, recordedAt: DateTime(2026,3,6)),
  Mood(userId: "1", moodType: Emotions.HAPPY, intensity: 5, recordedAt: DateTime(2026,3,7)),
  Mood(userId: "1", moodType: Emotions.SAD, intensity: 2, recordedAt: DateTime(2026,3,8)),
  Mood(userId: "1", moodType: Emotions.HAPPY, intensity: 5, recordedAt: DateTime(2026,3,9)),
  Mood(userId: "1", moodType: Emotions.ANGRY, intensity: 4, recordedAt: DateTime(2026,3,10)),
  Mood(userId: "1", moodType: Emotions.CALM, intensity: 4, recordedAt: DateTime(2026,3,11)),
  Mood(userId: "1", moodType: Emotions.SAD, intensity: 3, recordedAt: DateTime(2026,3,12)),
  Mood(userId: "1", moodType: Emotions.ANXIOUS, intensity: 4, recordedAt: DateTime(2026,3,13)),
  Mood(userId: "1", moodType: Emotions.TIRED, intensity: 3, recordedAt: DateTime(2026,3,14)),
  Mood(userId: "1", moodType: Emotions.CALM, intensity: 4, recordedAt: DateTime(2026,3,15)),
  Mood(userId: "1", moodType: Emotions.HAPPY, intensity: 5, recordedAt: DateTime(2026,3,16)),
  Mood(userId: "1", moodType: Emotions.SAD, intensity: 3, recordedAt: DateTime(2026,3,17)),
  Mood(userId: "1", moodType: Emotions.HAPPY, intensity: 5, recordedAt: DateTime(2026,3,18)),
  Mood(userId: "1", moodType: Emotions.ANXIOUS, intensity: 4, recordedAt: DateTime(2026,3,19)),
  Mood(userId: "1", moodType: Emotions.TIRED, intensity: 2, recordedAt: DateTime(2026,3,20)),
  Mood(userId: "1", moodType: Emotions.CALM, intensity: 4, recordedAt: DateTime(2026,3,21)),
  Mood(userId: "1", moodType: Emotions.HAPPY, intensity: 5, recordedAt: DateTime(2026,3,22)),
  Mood(userId: "1", moodType: Emotions.SAD, intensity: 2, recordedAt: DateTime(2026,3,23)),
  Mood(userId: "1", moodType: Emotions.CALM, intensity: 4, recordedAt: DateTime(2026,3,24)),
  Mood(userId: "1", moodType: Emotions.TIRED, intensity: 3, recordedAt: DateTime(2026,3,25)),
  Mood(userId: "1", moodType: Emotions.CALM, intensity: 4, recordedAt: DateTime(2026,3,26)),
  Mood(userId: "1", moodType: Emotions.HAPPY, intensity: 5, recordedAt: DateTime(2026,3,27)),
  Mood(userId: "1", moodType: Emotions.ANXIOUS, intensity: 4, recordedAt: DateTime(2026,3,28)),
  Mood(userId: "1", moodType: Emotions.CALM, intensity: 4, recordedAt: DateTime(2026,3,29)),
  Mood(userId: "1", moodType: Emotions.HAPPY, intensity: 5, recordedAt: DateTime(2026,3,30)),
];

  Future<List<Mood>> get30DayMoodsMock() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockMoods;
  }

}