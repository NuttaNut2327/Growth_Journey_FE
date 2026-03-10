import 'package:fe/pages/group/enum/role_participant.dart';

class ParticipantGroup {
  final String groupId;
  final RoleParticipant role;

  ParticipantGroup({required this.groupId, required this.role});

  factory ParticipantGroup.fromJson(Map<String, dynamic> json) {
    try {
      return ParticipantGroup(
        groupId: json['group_id'] as String,
        role: RoleParticipant.values.firstWhere(
          (e) => e.label == json['role'],
          orElse: () => RoleParticipant.MEMBER 
        ),
      );
    } catch (e) {
      throw Exception('Failed to parse ParticipantGroup: $e'); 
    }
  }
}