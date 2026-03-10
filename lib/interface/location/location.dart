// {{path}}/locations/status?status=approved
// {
//     "locations": [
//         {
//             "ID": "0bc7484b-8e04-48af-bef3-0abc79d619ab",
//             "name": "Lumpini Park",
//             "description": "Public park in Bangkok",
//             "latitude": 13.730071,
//             "longitude": 100.541145,
//             "type": [
//                 "park"
//             ],
//             "status": "approved",
//             "created_by": "a5dfe76b-479c-4999-9daa-bdd712688833",
//             "created_at": "2026-02-17T15:37:35.081927Z",
//             "updated_at": "2026-02-17T15:37:35.081995Z"
//         },
//         {
//             "ID": "69bd2a83-a720-45c8-a2bc-c0bd213e90b9",
//             "name": "Morning Meditation Walk",
//             "description": "Join us for a peaceful walk through the botanical gardens. We'll practice walking meditation...",
//             "latitude": 14.730071,
//             "longitude": 100.541145,
//             "type": [
//                 "park",
//                 "Nature",
//                 "Meditation"
//             ],
//             "status": "approved",
//             "created_by": "a5dfe76b-479c-4999-9daa-bdd712688833",
//             "created_at": "2026-02-17T17:10:25.846425Z",
//             "updated_at": "2026-02-17T17:10:25.846471Z"
//         },
//         {
//             "ID": "83e450dd-f687-4a27-b53d-3a47ad355ab5",
//             "name": "Community Art Center",
//             "description": "Community Art Center gallery ",
//             "latitude": 14.730071,
//             "longitude": 101.541145,
//             "type": [
//                 "art",
//                 "creative"
//             ],
//             "status": "approved",
//             "created_by": "a5dfe76b-479c-4999-9daa-bdd712688833",
//             "created_at": "2026-02-17T16:55:43.830881Z",
//             "updated_at": "2026-02-17T16:55:43.830916Z"
//         }
//     ]
// }

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
