import 'package:fe/pages/map/enum/location_type.dart';

class Location {
  final String id;
  final String name;
  final String address;
  final String description;
  final double latitude;
  final double longitude;
  final LocationType type;

  Location({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['ID'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      type: LocationType.values.firstWhere(
        (e) => e.name.toLowerCase().trim() ==
            json['type'].toString().toLowerCase().trim(),
        orElse: () => LocationType.other,
      ),
    );
  }
}