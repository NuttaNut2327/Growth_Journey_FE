import 'package:fe/api/group/getAllActiveGroup.dart';
import 'package:fe/api/group/joinGroup.dart';
import 'package:fe/api/group/leaveGroup.dart';
import 'package:fe/pages/group/models/group_model.dart';

class GroupRepository {
  Future<List<Group>> getGroups() async {
    try {
      final groups = await getAllActiveGroup();
      return groups;
    } catch (e) {
      throw Exception("Failed to fetch groups: $e");
    }
  }

  Future<void> joinGroup(String groupId) async {
    try {
      await joinGroupApi(groupId);
    } catch (e) {
      throw Exception("Failed to join group: $e");
    }
  }

  Future<void> leaveGroup(String groupId) async {
    try {
      await leaveGroupApi(groupId);
    } catch (e) {
      throw Exception("Failed to leave group: $e");
    }
  }
}
