import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/map/models/check_location_model.dart';

Future<CheckLocation> createLocationByUrl(String url) async {
  final api = ApiClient();

  try {
    final response = await api.dio.post(
      '/locations/by-url',
      data: {'url': url},
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return CheckLocation.fromJson(data);
    }

    throw Exception('Invalid response format');
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception('Failed to parse location from URL');
    } else {
      throw Exception('Network error');
    }
  }
}
