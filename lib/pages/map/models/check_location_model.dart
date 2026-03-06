class CheckLocation {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  CheckLocation({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory CheckLocation.fromJson(Map<String, dynamic> json) {
    return CheckLocation(
      name: json['name'],
      address: json['address'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
    );
  }
}