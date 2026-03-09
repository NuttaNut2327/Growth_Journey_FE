import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/interface/auth/user.dart'; 

Future<User> getUserByID() async {
  final api = ApiClient();

  try {
    final response = await api.dio.get('/users/me');
    return User.fromJson(response.data);
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception("Failed to retrieve user");
    } else {
      throw Exception("Network error");
    }
  }
}