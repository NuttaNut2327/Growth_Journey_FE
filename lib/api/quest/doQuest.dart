import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';

Future<void> doQuest(String questId, Uint8List imageBytes) async {
  final api = ApiClient();

  final formData = FormData.fromMap({
    'image': MultipartFile.fromBytes(imageBytes, filename: 'quest-proof.jpg'),
  });

  try {
    await api.dio.post(
      '/quests/$questId/do',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception('Failed to complete quest');
    } else {
      throw Exception('Network error');
    }
  }
}
