import 'package:fe/pages/group/enum/group_status.dart';
import 'package:fe/pages/group/enum/role_participant.dart';

class Activity {
  final String groupId;
  final String title;
  final String imagePath;
  final String description;
  final String locationId;
  final String location;
  final String eventDate;
  final int joinedMemberCount;
  final int targetMemberCount;
  final List<String> tags;
  final String createdBy;
  final DateTime createdAt;
  final GroupStatus status;
  final RoleParticipant role;

  Activity({
    required this.groupId,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.locationId,
    required this.location,
    required this.eventDate,
    required this.joinedMemberCount,
    required this.targetMemberCount,
    required this.tags,
    required this.createdBy,
    required this.createdAt,
    required this.status,
    required this.role,

  });

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      groupId: map['groupId'],
      title: map['title'],
      imagePath: map['imagePath'],
      description: map['description'],
      locationId: map['locationId'],
      location: map['location'],
      eventDate: map['eventDate'],
      joinedMemberCount: map['joinedMemberCount'],
      targetMemberCount: map['targetMemberCount'],
      tags: map['tags'],
      createdBy: map['createdBy'],
      createdAt: DateTime.parse(map['createdAt']),
      status: map['status'],
      role: map['role'],
    );
  }
}
