import 'package:fe/api/group/deleteGroup.dart';
import 'package:fe/api/group/getAllActiveGroup.dart';
import 'package:fe/api/group/getGroupByID.dart' as group_api;
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

  Future<Group> getGroup(String groupId) async {
    try {
      final group = await group_api.getGroup(groupId);
      return group;
    } catch (e) {
      throw Exception("Failed to fetch group: $e");
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

  Future<void> deleteGroup(String groupId) async {
    try {
      await deleteGroupApi(groupId);
    } catch (e) {
      throw Exception("Failed to delete group: $e");
    }
  }
}
