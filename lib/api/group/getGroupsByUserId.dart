import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/group/models/participant_group_model.dart';

Future<List<ParticipantGroup>> getGroupByID(String userId) async {
  final api = ApiClient();

  try {
    final response = await api.dio.get('/groups/$userId/groups');
    final responseData = response.data;
    if (responseData == null) {
      return [];
    }


    if (responseData is List) {
      return responseData
          .map((json) => ParticipantGroup.fromJson(json))
          .toList();
    }

    if (responseData is Map && responseData['data'] is List) {
      return (responseData['data'] as List)
          .map((json) => ParticipantGroup.fromJson(json))
          .toList();
    }

    return [];
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception("Failed to retrieve groups for user");
    } else {
      throw Exception("Network error");
    }
  }
}

