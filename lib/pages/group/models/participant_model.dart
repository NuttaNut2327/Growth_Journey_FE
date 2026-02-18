class Participant {
  final String userId;
  final String name;
  final String? imagePath;
  final String role;

  Participant({
    required this.userId,
    required this.name,
    this.imagePath,
    required this.role,
  });

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      userId: map['userId'],
      name: map['name'],
      imagePath: map['imagePath'],
      role: map['role'],
    );
  }
}
