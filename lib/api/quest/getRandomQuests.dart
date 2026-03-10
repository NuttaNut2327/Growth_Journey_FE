import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/heal/models/quest_model.dart';

Future<List<Quest>> getRandomQuests() async {
  final api = ApiClient();

  try {
    final response = await api.dio.get('/quests/random');
    final responseData = response.data;

    if (responseData == null) {
      return [];
    }

    if (responseData is List) {
      return responseData.map((json) => Quest.fromMap(json)).toList();
    }

    if (responseData is Map && responseData['data'] is List) {
      return (responseData['data'] as List)
          .map((json) => Quest.fromMap(json))
          .toList();
    }

    return [];
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception('Failed to retrieve daily quests');
    } else {
      throw Exception('Network error');
    }
  }
}
