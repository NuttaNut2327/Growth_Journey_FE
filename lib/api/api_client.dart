import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio dio = Dio();
  final _storage = const FlutterSecureStorage();

  ApiClient() {
    final baseUrl = dotenv.env['API_URL'];

    if (baseUrl == null) {
      throw Exception("API_URL is not set in .env");
    }

    dio.options.baseUrl = baseUrl; 
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await _storage.read(key: 'token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
           throw Exception("Unauthorized: Please log in again");
          }
          return handler.next(e);
        },
      ),
    );
  }
}