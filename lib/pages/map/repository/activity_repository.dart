import 'package:fe/api/group/getGroupsByLocation.dart';
import 'package:fe/pages/group/models/group_model.dart';

class ActivityRepository {
  Future<List<Group>> getActivitiesByLocation(String locationId) async {
    final groups = await getGroupsByLocation(locationId);
    return groups;
  }
}
