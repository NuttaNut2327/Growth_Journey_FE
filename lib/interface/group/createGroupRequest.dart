import 'dart:typed_data';

class GroupRequest {
  final String title;
  final String description;
  final int targetMemberCount;
  final String eventDate; 
  final String location; 
  final List<String> tags;
  final Uint8List? imageBytes;

  GroupRequest({
    required this.title,
    required this.description,
    required this.targetMemberCount,
    required this.eventDate,
    required this.location,
    required this.tags,
    this.imageBytes,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "target_member_count": targetMemberCount,
      "date": eventDate,
      "location_id": location,
      "tags": tags,
    };
  }
}