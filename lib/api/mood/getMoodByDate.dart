import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/home/enum/emotions.dart';

class TodayMood {
  final Emotions emotion;
  final int intensity;

  const TodayMood({
    required this.emotion,
    required this.intensity,
  });
}

Future<TodayMood?> getMoodByDate(DateTime date) async {
  final api = ApiClient();
  final formattedDate = _formatDate(date);

  try {
    final response = await api.dio.get(
      '/moods/date',
      queryParameters: {'date': formattedDate},
    );

    final parsed = _parseSingleMood(response.data);
    if (parsed != null) {
      return parsed;
    }
  } on DioException {
  }

  try {
    final response = await api.dio.get(
      '/moods',
      queryParameters: {
        'date_start': formattedDate,
        'date_end': formattedDate,
      },
    );

    final parsedFromList = _parseFirstMoodFromCollection(response.data);
    if (parsedFromList != null) {
      return parsedFromList;
    }

    return null;
  } on DioException catch (e) {
    final payload = e.response?.data;
    if (payload is Map<String, dynamic> && payload['message'] != null) {
      throw Exception(payload['message']);
    }
    throw Exception('Failed to fetch today mood');
  }
}

TodayMood? _parseSingleMood(dynamic data) {
  if (data == null) {
    return null;
  }

  if (data is Map) {
    final map = Map<String, dynamic>.from(data);

    if (map['data'] is Map) {
      final nested = Map<String, dynamic>.from(map['data'] as Map);
      if (nested['mood_type'] != null) {
        return _fromJson(nested);
      }
    }

    if (map['data'] is List) {
      final fromCollection = _parseFirstMoodFromCollection(map['data']);
      if (fromCollection != null) {
        return fromCollection;
      }
    }

    if (map['mood_type'] == null) {
      return null;
    }

    return _fromJson(map);
  }

  return null;
}

TodayMood? _parseFirstMoodFromCollection(dynamic data) {
  if (data is List && data.isNotEmpty) {
    final first = data.first;
    if (first is Map) {
      final map = Map<String, dynamic>.from(first);
      if (map['mood_type'] != null) {
        return _fromJson(map);
      }
    }
  }

  if (data is Map && data['data'] is List) {
    final list = data['data'] as List;
    if (list.isNotEmpty && list.first is Map) {
      final map = Map<String, dynamic>.from(list.first as Map);
      if (map['mood_type'] != null) {
        return _fromJson(map);
      }
    }
  }

  return null;
}

TodayMood _fromJson(Map<String, dynamic> json) {
  final moodRaw = (json['mood_type'] ?? '').toString().toLowerCase();
  final emotion = Emotions.values.firstWhere(
    (item) => item.label == moodRaw,
    orElse: () => Emotions.CALM,
  );

  return TodayMood(
    emotion: emotion,
    intensity: (json['intensity'] as num?)?.toInt() ?? 1,
  );
}

String _formatDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
