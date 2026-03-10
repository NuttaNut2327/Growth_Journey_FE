import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/interface/location/location.dart';

Future<List<Location>> getLocationsByStatus(String status) async {
  final api = ApiClient();

  try {
    final response = await api.dio.get(
      '/locations/status',
      queryParameters: {'status': status},
    );

    final payload = response.data;
    final list = payload is List
        ? payload
        : (payload is Map<String, dynamic> && payload['locations'] is List
            ? payload['locations'] as List
            : const []);

    return list
        .whereType<Map>()
        .map((json) => Location.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception("Failed to retrieve locations by status");
    } else {
      throw Exception("Network error");
    }
  }
}
