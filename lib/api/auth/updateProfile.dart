import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:fe/api/api_client.dart';
import 'package:fe/interface/auth/updateProfileRequest.dart';
import 'package:fe/interface/auth/user.dart';

Future<User> updateProfile(UpdateProfileRequest request) async {
  final api = ApiClient();

  final formData = FormData();

  if (request.image != null) {
    final file = request.image!;
    if (await file.exists()) {
      final fileName = p.basename(file.path);
      formData.files.add(MapEntry(
        'imagePath',
        await MultipartFile.fromFile(file.path, filename: fileName),
      ));
    }
  }

  formData.fields.addAll([
    MapEntry("username", request.username),
    MapEntry("first_name", request.firstName),
    MapEntry("last_name", request.lastName),
    MapEntry("email", request.email),
    MapEntry("gender", request.gender),
    MapEntry("birthdate", request.birthdate),
    MapEntry("phone", request.phone),
  ]);

  try {
    final response = await api.dio.patch(
      '/user/me',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return User.fromJson(response.data);
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception("Registration failed");
    } else {
      throw Exception("Network error");
    }
  }
}
