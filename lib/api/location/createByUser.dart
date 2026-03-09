import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';

Future<void> createLocationByUser({
  required String name,
  required String description,
  required String address,
  required double latitude,
  required double longitude,
  required String type,
}) async {
  final api = ApiClient();

  try {
    await api.dio.post(
      '/locations',
      data: {
        'name': name,
        'description': description,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'type': type,
        'status': 'pending',
      },
    );
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception('Failed to create location request');
    }

    throw Exception('Network error');
  }
}
