import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/interface/location/location.dart';

Future<List<Location>> getLocationsByStatus(String status) async {
  final api = ApiClient();

  try {
    final response = await api.dio.get('/locations/status', queryParameters: {'status': status});
    
    final List data = response.data['locations'];

    return data.map((json) => Location.fromJson(json)).toList();
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data.locations;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception("Failed to retrieve locations by status");
    } else {
      throw Exception("Network error");
    }
  }
}