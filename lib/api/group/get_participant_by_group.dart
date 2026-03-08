import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/group/models/participant_model.dart';

Future<List<Participant>> getParticipantByGroup(String groupId) async {
  final api = ApiClient();
  try {
    final response = await api.dio.get('/groups/$groupId/participants');
    final dynamic responseData = response.data;

if (responseData is List) {
      return responseData.map((json) => Participant.fromMap(json)).toList();
    } else if (responseData is Map && responseData['data'] != null) {
      return (responseData['data'] as List).map((json) => Participant.fromMap(json)).toList();
    }
    
    return [];
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception("Failed to retrieve participants for group");
    } else {
      throw Exception("Network error");
    }
  }
}
