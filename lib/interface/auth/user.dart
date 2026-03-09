// {
//     "id": "aaf4ab7f-5d10-437c-818d-188608389ade",
//     "username": "yuuka_",
//     "first_name": "Yuuka",
//     "last_name": "Kawai",
//     "gender": "female",
//     "birthdate": "2001-04-19",
//     "phone": "0812345678",
//     "email": "yuuka1@example.com",
//     "level": 0,
//     "points": 0
//     "image_url" : null
// }

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
