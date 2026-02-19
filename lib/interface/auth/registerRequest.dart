class RegisterRequest {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String gender;
  final String birthdate;
  final String phone;

  RegisterRequest({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.birthdate,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "gender": gender,
      "birthdate": birthdate,
      "phone": phone,
    };
  }
}
