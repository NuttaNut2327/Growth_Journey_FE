import 'package:fe/pages/group/models/group_model.dart';
import 'package:fe/pages/group/models/participant_group_model.dart';
import 'package:fe/pages/group/repository/group_by_partcipant.dart';
import 'package:fe/pages/group/repository/group_repository.dart';
import 'package:fe/services/auth_service.dart';

class GroupPageData {
  final List<Group> allGroups;
  final List<ParticipantGroup> joinedGroups;

  GroupPageData({required this.allGroups, required this.joinedGroups});
}

class GroupPageService {
  Future<List<ParticipantGroup>> getGroupByUserId(String groupId) async {
    final userId = await getUserId();
    final repo = GroupByUserIDRepository(userId != null ? Future.value(userId) : Future.value(null));

    try {
      final participants = await repo.getGroupsByUserId(groupId);
      return participants;
    } catch (e) {
      throw Exception("Failed to fetch participants: $e");
    }
  }

  Future<GroupPageData> load() async {
    final userId = await getUserId();
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final groupRepo = GroupRepository();
    final participantRepo = GroupByUserIDRepository(Future.value(userId));

    final results = await Future.wait([
      groupRepo.getGroups(),
      participantRepo.getGroupsByUserId(userId),
    ]);

    return GroupPageData(
      allGroups: results[0] as List<Group>,
      joinedGroups: results[1] as List<ParticipantGroup>,
    );
  }
}
