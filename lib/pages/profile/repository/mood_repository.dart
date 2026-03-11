import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/profile/models/mood_model.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class MoodRepository {
  Future<List<Mood>> getMoodsInCurrentMonth() async {
    final api = ApiClient();
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    final dateStart = _formatDate(startOfMonth);
    final dateEnd = _formatDate(now);

    try {
      final response = await api.dio.get(
        '/moods',
        queryParameters: {
          'date_start': dateStart,
          'date_end': dateEnd,
        },
      );
      return _parseMoodList(response.data);
    } on DioException catch (e1) {
      try {
        final response = await api.dio.get(
          '/moods?date_start=$dateStart&date_end=$dateEnd',
        );
        return _parseMoodList(response.data);
      } on DioException catch (e2) {
        try {
          final fallback = await api.dio.get('/moods');
          return _parseMoodList(fallback.data);
        } on DioException catch (e3) {
          final message = _extractMessage(e3) ??
              _extractMessage(e2) ??
              _extractMessage(e1) ??
              'Failed to fetch moods';
          debugPrint('Mood API failed: $message');
          return [];
        }
      }
    }
  }

  List<Mood> _parseMoodList(dynamic raw) {
    final list = raw is List
        ? raw
        : (raw is Map<String, dynamic> && raw['data'] is List
            ? raw['data'] as List
            : const []);

    return list
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(Mood.fromJson)
        .toList();
  }

  String? _extractMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return null;
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
