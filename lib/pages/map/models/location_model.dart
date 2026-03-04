import 'package:fe/pages/map/enum/location_type.dart';

class Location {
  final String id;
  final String name;
  final String description;
  final String latitude;
  final String longitude;
  final LocationType type;

  Location({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['ID'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      type: LocationType.values.firstWhere(
        (e) => e.name.toLowerCase().trim() ==
            json['type'].toString().toLowerCase().trim(),
        orElse: () => LocationType.other,
      ),
    );
  }
}