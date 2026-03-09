import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/pages/group/enum/group_status.dart';
import 'package:fe/pages/group/models/group_model.dart';

Future<List<Group>> getGroupsByLocation(String locationId) async {
  final api = ApiClient();

  try {
    final response = await api.dio.get('/groups/location/$locationId');
    final data = response.data;

    if (data == null) {
      return [];
    }

    if (data is List) {
      return data.map((json) {
        final map = json as Map<String, dynamic>;
        return Group(
          groupId: map['id']?.toString() ?? '',
          title: map['title']?.toString() ?? '',
          imagePath:
              map['image_url']?.toString() ??
              'https://jkfenner.com/wp-content/uploads/2019/11/default.jpg',
          description: map['description']?.toString() ?? '',
          location: map['location_name']?.toString() ?? '',
          eventDate:
              map['date']?.toString() ?? DateTime.now().toIso8601String(),
          joinedMemberCount: _toInt(map['joined_member_count']),
          targetMemberCount: _toInt(map['target_member_count']),
          tags: List<String>.from(map['tags'] ?? []),
          status: GroupStatus.NOT_JOINED,
        );
      }).toList();
    }

    return [];
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception('Failed to fetch groups by location');
    }

    throw Exception('Network error');
  }
}

int _toInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}
