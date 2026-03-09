import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/blog/models/blog_model.dart';


Future<List<Blog>> getBlogs() async {
  final api = ApiClient();

  try {
    final response = await api.dio.get(
      '/blogs'
    );

    final data = response.data;
    if (data == null) {
      return [];
    }

    if (data is List) {
      return data
          .map((json) => Blog.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((json) => Blog.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception('Failed to fetch approved blogs');
    }

    throw Exception('Network error');
  }
}
