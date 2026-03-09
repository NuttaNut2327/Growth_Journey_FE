import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';

Future<void> leaveGroupApi(String groupId) async {
  final api = ApiClient();

  try {
    await api.dio.post('/groups/$groupId/leave');
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception('Failed to leave group');
    } else {
      throw Exception('Network error');
    }
  }
}
