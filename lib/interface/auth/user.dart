class User {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime birthdate;
  final String phone;
  final String email;
  final int level;
  final int points;
  final String? imageUrl;
  final int? ranking;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
    required this.phone,
    required this.email,
    required this.level,
    required this.points,
    this.imageUrl,
    this.ranking,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      birthdate: DateTime.parse(json['birthdate']),
      phone: json['phone'],
      email: json['email'],
      level: json['level'],
      points: json['points'],
      imageUrl: json['image_url'],
      ranking: json['ranking'],
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}
