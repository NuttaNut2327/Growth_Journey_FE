import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/interface/auth/loginRequest.dart';
import 'package:fe/services/fcm_notification_service.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode, kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> login(LoginRequest request) async {
  final api = ApiClient();

  if (kDebugMode) {
    debugPrint('API_URL in login: ${api.dio.options.baseUrl}');
  }

  try {
    Response<dynamic>? response;
    DioException? lastRetryableError;

    for (var attempt = 1; attempt <= 3; attempt++) {
      try {
        response = await api.dio.post(
          '/auth/login',
          data: request.toJson(),
        );
        lastRetryableError = null;
        break;
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        final isRetryable = e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError ||
            status == 502 ||
            status == 503 ||
            status == 504;

        if (!isRetryable || attempt == 3) {
          rethrow;
        }

        lastRetryableError = e;
        if (kDebugMode) {
          debugPrint(
            'Login retry $attempt/3 due to transient network error: ${e.type}',
          );
        }
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    if (response == null) {
      throw lastRetryableError ?? Exception('Login failed');
    }

    final data = response.data;
    final token = data is Map<String, dynamic> ? data['accessToken'] : null;

    if (token is! String || token.isEmpty) {
      throw Exception('Invalid login response');
    }

    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);

    if (!kIsWeb) {
      unawaited(
        Future<void>(() async {
          try {
            await FCMNotificationService().syncTokenWithBackend();
          } catch (_) {}
        }),
      );
    }
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;
      final statusCode = e.response?.statusCode;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      if (statusCode == 401) {
        throw Exception('Invalid username or password');
      }

      if (statusCode == 403) {
        throw Exception('Access denied');
      }

      if (statusCode == 502 || statusCode == 503 || statusCode == 504) {
        throw Exception('Service is temporarily unavailable, please try again');
      }

      if (statusCode != null && statusCode >= 500) {
        throw Exception('Server error, please try again');
      }

      throw Exception("Login failed");
    } else {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Connection timeout, please try again');
      }

      throw Exception("Network error: cannot reach server");
    }
  }
}
