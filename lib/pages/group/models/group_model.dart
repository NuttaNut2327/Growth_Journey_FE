class Group {
  final String id;
  final String title;
  final String description;
  final int targetMemberCount;
  final int joinedMemberCount;
  final String? image;
  final DateTime date;
  final String locationId;
  final String location;
  final List<String> tags;
  final String createdBy;
  final DateTime createdAt;

  Group({
    required this.id,
    required this.title,
    required this.description,
    required this.targetMemberCount,
    required this.joinedMemberCount,
    required this.date,
    this.image,
    required this.locationId,
    required this.location,
    required this.tags,
    required this.createdBy,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      targetMemberCount: _toInt(json['target_member_count']),
      joinedMemberCount: _toInt(json['joined_member_count']),
      image: json['image_url']?.toString(),
      date: _toDate(json['date']),
      locationId: json['location_id']?.toString() ?? '',
      location: (json['location_name']) ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      createdBy: json['created_by']?.toString() ?? '',
      createdAt: _toDate(json['created_at']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime _toDate(dynamic value) {
    if (value is String) {
      final parsed = DateTime.tryParse(value) ?? DateTime.now();
      return parsed.add(const Duration(hours: 7));
    }
    return DateTime.now().add(const Duration(hours: 7));
  }

  static String _formatThaiDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        final thaiDate = parsed.add(const Duration(hours: 7));
        return thaiDate.toString().split(' ')[0];
    }
    return '';
  }
}
