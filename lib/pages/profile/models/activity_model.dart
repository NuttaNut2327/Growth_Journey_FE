import 'package:fe/pages/group/enum/group_status.dart';
import 'package:fe/pages/group/enum/role_participant.dart';

class Activity {
  final String groupId;
  final String title;
  final String imagePath;
  final String description;
  final String location;
  final String eventDate;
  final int joinedMemberCount;
  final int targetMemberCount;
  final String tags;
  final GroupStatus status;
  final RoleParticipant role;

  Activity({
    required this.groupId,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.joinedMemberCount,
    required this.targetMemberCount,
    required this.tags,
    required this.status,
    required this.role,

  });

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      groupId: map['groupId'],
      title: map['title'],
      imagePath: map['imagePath'],
      description: map['description'],
      location: map['location'],
      eventDate: map['eventDate'],
      joinedMemberCount: map['joinedMemberCount'],
      targetMemberCount: map['targetMemberCount'],
      tags: map['tags'],
      status: map['status'],
      role: map['role'],
    );
  }
}
