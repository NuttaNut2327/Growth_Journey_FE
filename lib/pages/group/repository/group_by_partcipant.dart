import 'package:fe/api/group/getGroupsByUserId.dart';
import 'package:fe/pages/group/models/participant_group_model.dart';

class GroupByUserIDRepository {
  Future<List<ParticipantGroup>> getGroupsByUserId(String userId) async {
    try {
      final groups = await getGroupByID(userId);
      return groups;
    } catch (e) {
      throw Exception("Failed to fetch groups by user ID: $e");
    }
  }
}
