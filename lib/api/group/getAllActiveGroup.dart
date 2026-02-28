import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/group/models/group_model.dart';

Future<List<Group>> getAllActiveGroup() async {
  final api = ApiClient();

  try {
    final response = await api.dio.get("/groups");

    final List data = response.data;

    return data.map((json) => Group.fromJson(json)).toList();
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception("Failed to retrieve active groups");
    } else {
      throw Exception("Network error");
    }
  }
}
