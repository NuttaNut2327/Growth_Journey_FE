import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/interface/auth/user.dart';

Future<List<User>> getAllUsersWithRanking() async {
  final api = ApiClient();

  try {
    final response = await api.dio.get('/users/all');
    if (response.data == null) {
      return [];
    }
    if (response.data is List) {
      return (response.data as List)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Invalid response format');
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;  
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }
      throw Exception('Failed to retrieve users');
    }
    throw Exception('Network error');
  }

}