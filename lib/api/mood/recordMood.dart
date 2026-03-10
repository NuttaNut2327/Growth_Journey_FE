import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/home/enum/emotions.dart';

Future<void> recordMood({
  required Emotions emotion,
  required int intensity,
}) async {
  final api = ApiClient();

  try {
    await api.dio.post(
      '/moods',
      data: {
        'mood_type': emotion.name,
        'intensity': intensity,
      },
    );
  } on DioException catch (e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      if (message != null && message.isNotEmpty) {
        throw Exception(message);
      }
    }

    if (e.response?.statusCode == 409) {
      throw Exception('You already recorded your mood today');
    }

    throw Exception('Failed to record mood');
  }
}
