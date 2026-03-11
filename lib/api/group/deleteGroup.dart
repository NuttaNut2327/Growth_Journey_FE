import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';

Future<void> deleteGroupApi(String groupId) async {
  final api = ApiClient();

  try {
    await api.dio.delete('/groups/$groupId');
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception('Failed to delete group');
    } else {
      throw Exception('Network error');
    }
  }
}
