import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/interface/auth/loginRequest.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> login(LoginRequest request) async {
  final api = ApiClient();

  try {
    final response = await api.dio.post(
      '/auth/login',
      data: request.toJson(),
    );

    final token = response.data['accessToken'];

    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);

  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;
      
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception("Login failed");
    } else {
      throw Exception("Network error");
    }
  }
}
