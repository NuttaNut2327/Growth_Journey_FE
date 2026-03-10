import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/interface/auth/user.dart'; 

Future<User> getUserByID() async {
  final api = ApiClient();

  try {
    Response<dynamic>? response;

    for (var attempt = 1; attempt <= 2; attempt++) {
      try {
        response = await api.dio.get('/users/me');
        break;
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        final isRetryable = e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError ||
            status == 500 ||
            status == 502 ||
            status == 503 ||
            status == 504;

        if (!isRetryable || attempt == 2) {
          rethrow;
        }

        await Future.delayed(const Duration(milliseconds: 700));
      }
    }

    if (response == null) {
      throw Exception('Failed to retrieve user');
    }

    return User.fromJson(response.data);
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception("Failed to retrieve user");
    } else {
      throw Exception("Network error");
    }
  }
}