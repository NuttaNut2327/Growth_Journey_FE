class Location {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> type;
  final String status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Location({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    final rawType = json['type'];
    final parsedType = rawType is List
        ? rawType.map((e) => e.toString()).toList()
        : (rawType is String && rawType.isNotEmpty
            ? <String>[rawType]
            : <String>[]);

    return Location(
      id: (json['id'] ?? json['ID'] ?? '').toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      type: parsedType,
      status: json['status'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
      'status': status,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
