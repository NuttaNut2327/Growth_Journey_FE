import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/interface/auth/registerRequest.dart';

Future<void> register(RegisterRequest request) async {
  final api = ApiClient();

  FormData formData = FormData.fromMap({
    "username": request.username,
    "first_name": request.firstName,
    "last_name": request.lastName,
    "email": request.email,
    "password": request.password,
    "gender": request.gender,
    "birthdate": request.birthdate,
    "phone": request.phone,
  });

  try {
    await api.dio.post(
      '/auth/register',
      data: formData,
    );
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
