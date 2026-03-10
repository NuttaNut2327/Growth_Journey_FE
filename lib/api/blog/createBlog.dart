import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';

Future<void> createBlogApi(String content) async {
  final api = ApiClient();

  try {
    await api.dio.post('/blogs', data: {'content': content});
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }
      throw Exception('Failed to create blog');
    }
    throw Exception('Network error');
  }
}
