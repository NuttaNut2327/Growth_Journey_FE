import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';

Future<void> unlikeBlogApi(String blogId) async {
  final api = ApiClient();

  try {
    await api.dio.post('/blogs/$blogId/unlike');
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }
      throw Exception('Failed to unlike blog');
    }
    throw Exception('Network error');
  }
}
