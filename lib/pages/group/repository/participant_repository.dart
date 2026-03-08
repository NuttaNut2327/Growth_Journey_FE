import 'package:fe/api/group/get_participant_by_group.dart';
import 'package:fe/pages/group/models/participant_model.dart';

class ParticipantRepository {
  Future<List<Participant>> getParticipantsByGroup(String groupId) async {
    try {
      final participants = await getParticipantByGroup(groupId);
      return participants;
    } catch (e) {
      rethrow;
    }
  }
}
