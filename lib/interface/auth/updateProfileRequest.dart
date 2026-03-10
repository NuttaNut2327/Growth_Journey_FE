import 'dart:io';

class UpdateProfileRequest {
  final File? image; // local file to upload
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String birthdate;
  final String phone;

  UpdateProfileRequest({
    this.image,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.birthdate,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    // helper for non-file fields (not used by updateProfile directly)
    final data = {
      "username": username,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "gender": gender,
      "birthdate": birthdate,
      "phone": phone,
    };

    if (image != null) {
      data["imagePath"] = image!.path;
    }

    return data;
  }
}
