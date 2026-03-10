import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/group/enum/role_participant.dart';
import 'package:fe/pages/profile/models/activity_model.dart';
import 'package:fe/pages/group/enum/group_status.dart';

class ActivityRepository {
  Future<List<Activity>> getActivitiesByUserId(String userId) async {
    final api = ApiClient();

    try {
      // Preferred endpoint from profile requirements.
      final response = await api.dio.get('/users/history');
      return _parseActivities(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Backward compatibility with existing backend route.
        final fallback = await api.dio.get('/groups/history');
        return _parseActivities(fallback.data);
      }

      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        final message = data['message']?.toString();
        if (message != null && message.isNotEmpty) {
          throw Exception(message);
        }
      }

      throw Exception('Failed to load activities');
    }
  }

  List<Activity> _parseActivities(dynamic raw) {
    final list = raw is List
        ? raw
        : (raw is Map<String, dynamic> && raw['data'] is List
            ? raw['data'] as List
            : const []);

    return list.whereType<Map<String, dynamic>>().map(_fromJson).toList();
  }

  Activity _fromJson(Map<String, dynamic> json) {
    final roleRaw = (json['role'] ?? '').toString().toUpperCase();
    final statusRaw = (json['status'] ?? '').toString().toLowerCase();

    final role = roleRaw == RoleParticipant.CREATOR.name
        ? RoleParticipant.CREATOR
        : RoleParticipant.MEMBER;

    final status = switch (statusRaw) {
      'joined' => GroupStatus.JOINED,
      'owner' => GroupStatus.OWNER,
      _ => GroupStatus.NOT_JOINED,
    };

    return Activity(
      groupId: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      imagePath: (json['image_url'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      locationId: (json['location_id'] ?? '').toString(),
      location: (json['location_name'] ?? '').toString(),
      eventDate: (json['date'] ?? '').toString(),
      joinedMemberCount: _toInt(json['joined_member_count']),
      targetMemberCount: _toInt(json['target_member_count']),
      tags:
          (json['tags'] as List? ?? const []).map((e) => e.toString()).toList(),
      createdBy: (json['created_by'] ?? '').toString(),
      createdAt: _toDate(json['created_at']),
      status: status,
      role: role,
    );
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  DateTime _toDate(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
