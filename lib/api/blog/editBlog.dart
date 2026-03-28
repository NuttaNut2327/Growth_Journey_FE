import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';

Future<void> editBlogApi(String blogId, String content) async {
  final api = ApiClient();

  try {
    await api.dio.put('/blogs/$blogId', data: {'content': content});
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }
      throw Exception('Failed to edit blog');
    }
    throw Exception('Network error');
  }
}
