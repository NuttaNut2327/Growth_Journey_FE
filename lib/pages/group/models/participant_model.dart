import 'package:fe/pages/group/enum/role_participant.dart';

class Participant {
  final String userId;
  final String name;
  final String? imagePath;
  final RoleParticipant role;

  Participant({
    required this.userId,
    required this.name,
    this.imagePath,
    required this.role,
  });

  factory Participant.fromMap(Map<String, dynamic>  json) {
    return Participant(
      userId:  json['user_id'] as String ,
      name: json['name'] as String  ,
      imagePath: json['image_url']?.toString(),
      role: RoleParticipant.values.firstWhere((e) => e.label == json['role']),
    );
  }
}
