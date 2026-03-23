class UserRank {
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

  UserRank({
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

  factory UserRank.fromMap(Map<String, dynamic> map) {
    return UserRank(
      id: map['id'] ?? map['userId'] ?? '',
      username: map['username'] ?? '',
      firstName: map['first_name'] ?? map['firstName'] ?? '',
      lastName: map['last_name'] ?? map['lastName'] ?? '',
      gender: map['gender'] ?? '',
      birthdate: DateTime.tryParse(map['birthdate'] ?? '') ?? DateTime(2000),
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      level: map['level'] ?? 0,
      points: map['points'] ?? 0,
      imageUrl: map['image_url'] ?? map['imageUrl'],
      ranking: map['ranking'] ?? map['rank'],
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
    );
  }
}