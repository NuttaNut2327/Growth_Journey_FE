import 'package:fe/pages/group/enum/group_status.dart';

class Group {
  final String groupId;
  final String title;
  final String imagePath;
  final String description;
  final String location;
  final String eventDate;
  final int joinedMemberCount;
  final int targetMemberCount;
  final List<String> tags;
  final GroupStatus status;

  Group({
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
  });

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      groupId: map['groupId'],
      title: map['title'],
      imagePath: map['imagePath'],
      description: map['description'],
      location: map['location'],
      eventDate: map['eventDate'],
      joinedMemberCount: map['joinedMemberCount'],
      targetMemberCount: map['targetMemberCount'],
      tags: List<String>.from(map['tags']),
      status: map['status'],
    );
  }
}
