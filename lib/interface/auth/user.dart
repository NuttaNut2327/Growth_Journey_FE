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
    );
  }
}
