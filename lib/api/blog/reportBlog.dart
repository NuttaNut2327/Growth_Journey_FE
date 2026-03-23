import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/blog/models/report_model.dart';

Future<void> reportBlog(Report report) async {
  final api = ApiClient();

  try {
    await api.dio.post('/blogs/report', data: report.toJson());
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }
      throw Exception('Failed to report blog');
    }
    throw Exception('Network error');
  }
}
