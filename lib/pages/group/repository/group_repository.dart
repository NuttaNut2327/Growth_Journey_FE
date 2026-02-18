import 'package:fe/pages/group/models/group_model.dart';

class GroupRepository {

  final List<Group> _mockGroups = [
    Group.fromMap({
      'groupId': '3f9c2a74-8b1e-4f2d-a6c3-91e5b7d2637a',
      'title': 'Support Circle',
      'imagePath': 'assets/images/support_circle.jpg',
      'description':
          'A safe and welcoming space where you can openly share your thoughts, experiences, and emotions without fear of judgment. This weekly gathering encourages active listening, empathy, and mutual support among participants through guided conversation prompts and reflective activities that help build trust and connection. Whether you choose to speak, listen, or simply observe, the circle offers understanding, encouragement, and a strong sense of belonging in a calm and supportive environment.',
      'location': 'Wellness Center Room 3',
      'eventDate': '2026-02-10T09:30:45Z',
      'joinedMemberCount': 6,
      'targetMemberCount': 8,
      'tags': ['Mental Health', 'Group Talk'],
      'status': 'joined',
    }),
    Group.fromMap({
      'groupId': 'a7d5e3b1-2c4f-47a8-9d6b-0f12c8e9789d',
      'title': 'Morning Yoga Flow',
      'imagePath': 'assets/images/yoga_group.jpg',
      'description':
          'Begin your morning with a refreshing session of gentle yoga designed to awaken your body and calm your mind while improving flexibility and balance through guided stretches, breathing exercises, and mindful poses led by an experienced instructor. The session prioritizes relaxation over intensity and welcomes participants of all skill levels, helping reduce stress, boost energy, and cultivate focus so you can start your day with clarity, positivity, and renewed motivation.',
      'location': 'Community Hall',
      'eventDate': '2025-10-15T04:30:45Z',
      'joinedMemberCount': 2,
      'targetMemberCount': 15,
      'tags': ['Yoga', 'Wellness'],
      'status': 'not_joined',
    }),
    Group.fromMap({
      'groupId': '6b2f9d80-1a3c-4e57-b8f4-72d0a9c86e7b',
      'title': 'Creative Art Therapy',
      'imagePath': 'assets/images/art_therapy.jpg',
      'description':
          'Explore your emotions and express your inner thoughts through creative art activities in a calm and supportive setting where participants experiment with colors, textures, and materials to relax and reflect while connecting with their feelings in a nonjudgmental environment. Guided prompts encourage imagination and emotional awareness, and no artistic experience is required since the focus is on personal expression, healing, and enjoyment rather than technical perfection or artistic outcome.',
      'location': 'Art Room B',
      'eventDate': '2025-12-23T12:45:45Z',
      'joinedMemberCount': 1,
      'targetMemberCount': 8,
      'tags': ['Art', 'Therapy', 'Creative'],
      'status': 'not_joined',
    }),
  ];

  Future<List<Group>> getGroups() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockGroups;
  }
}
