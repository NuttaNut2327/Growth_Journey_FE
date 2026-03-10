import 'package:fe/pages/group/enum/role_participant.dart';
import 'package:fe/pages/profile/models/activity_model.dart';
import 'package:fe/pages/group/enum/group_status.dart';

class ActivityRepository {

  final Map<String, List<Activity>> _mockActivityData = {
    '1': [
      Activity(
        groupId: '3f9c2a74-8b1e-4f2d-a6c3-91e5b7d2637a',
        title: 'Group Activity 1',
        imagePath: 'https://i.pinimg.com/736x/e7/a0/32/e7a0323ead05bb13a9ad1f78135b51c1.jpg',
        description: 'Description for Group Activity 1',
        location: 'Location 1',
        eventDate: '2023-10-15',
        joinedMemberCount: 10,
        targetMemberCount: 20,
        tags: 'tag1',
        status: GroupStatus.JOINED,
        role: RoleParticipant.MEMBER
      ),
      Activity(
        groupId: '3f9c2a74-8b1e-4f2d-a6c3-91e5b7d2637a',
        title: 'Group Activity 2',
        imagePath: 'https://i.pinimg.com/736x/0a/cc/da/0accda430a16bd9b5c7ad7d699d5f3d7.jpg',
        description: 'Description for Group Activity 2',
        location: 'Location 2',
        eventDate: '2023-11-20',
        joinedMemberCount: 15,
        targetMemberCount: 30,
        tags: 'tag2',
        status: GroupStatus.JOINED,
        role: RoleParticipant.MEMBER
      ),
      Activity(
        groupId: '3f9c2a74-8b1e-4f2d-a6c3-91e5b7d2637a',
        title: 'Group Activity 3',
        imagePath: 'https://i.pinimg.com/736x/c9/74/23/c97423c2b49f178612406acb46c923f6.jpg',
        description: 'Description for Group Activity 3',
        location: 'Location 3',
        eventDate: '2023-12-05',
        joinedMemberCount: 20,
        targetMemberCount: 40,
        tags: 'tag3',
        status: GroupStatus.JOINED,
        role: RoleParticipant.MEMBER
       ),
      Activity(
        groupId: '3f9c2a74-8b1e-4f2d-a6c3-91e5b7d2637a',
        title: 'Group Activity 4',
        imagePath: 'https://i.pinimg.com/1200x/d4/a3/c2/d4a3c2cf522a1880a3c519c1f3d9257e.jpg',
        description: 'Description for Group Activity 4',
        location: 'Location 4',
        eventDate: '2024-01-10',
        joinedMemberCount: 25,
        targetMemberCount: 50,
        tags: 'tag4',
        status: GroupStatus.JOINED,
        role: RoleParticipant.CREATOR
       ),
    ],
    'a7d5e3b1-2c4f-47a8-9d6b-0f12c8e9789d': [
      Activity(
        groupId: 'a7d5e3b1-2c4f-47a8-9d6b-0f12c8e9789d',
        title: 'Group Activity 5',
        imagePath: 'https://i.pinimg.com/736x/0a/cc/da/0accda430a16bd9b5c7ad7d699d5f3d7.jpg',
        description: 'Description for Group Activity 5',
        location: 'Location 5',
        eventDate: '2024-02-15',
        joinedMemberCount: 30,
        targetMemberCount: 60,
        tags: 'tag5',
        status: GroupStatus.JOINED,
        role: RoleParticipant.CREATOR
      ),
    ],
  };

  Future<List<Activity>> getActivitiesByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400)); // simulate network
    return _mockActivityData[userId] ?? [];
  }
}
