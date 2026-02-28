import 'package:fe/api/group/getAllActiveGroup.dart';
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
}