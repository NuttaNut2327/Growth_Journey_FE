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
  Future<List<ParticipantGroup>> getGroupByUserId(String userId) async {
    final repo = GroupByUserIDRepository();

    try {
      final participants = await repo.getGroupsByUserId(userId);
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
    final participantRepo = GroupByUserIDRepository();

    final allGroups = await groupRepo.getGroups();

    List<ParticipantGroup> joinedGroups = [];
    try {
      joinedGroups = await participantRepo.getGroupsByUserId(userId);
    } catch (_) {
      joinedGroups = [];
    }

    return GroupPageData(
      allGroups: allGroups,
      joinedGroups: joinedGroups,
    );
  }
}
