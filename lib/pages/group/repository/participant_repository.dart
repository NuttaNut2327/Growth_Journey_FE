import 'package:fe/pages/group/models/participant_model.dart';

class ParticipantRepository {

  final Map<String, List<Participant>> _mockData = {
    '3f9c2a74-8b1e-4f2d-a6c3-91e5b7d2637a': [
      Participant(
        userId: '123e4567-e89b-12d3-a456-426614174023', 
        name: 'Twilight', 
        imagePath: 'https://i.pinimg.com/1200x/3c/11/f6/3c11f6372fec64103de3eef197a33f6e.jpg', 
        role: 'CREATOR'
      ),
      Participant(
        userId: '9f1c2d3e-4a5b-678c-9d0e-f1a2b3c4d5g8', 
        name: 'Amarela', 
        imagePath: 'https://i.pinimg.com/736x/0a/cc/da/0accda430a16bd9b5c7ad7d699d5f3d7.jpg', 
        role: 'MEMBER'
      ),
      Participant(
        userId: '7b8c9d0e-1f23-4567-89ab-cdef01264589', 
        name: 'Pinkie pie', 
        imagePath: 'https://i.pinimg.com/736x/c9/74/23/c97423c2b49f178612406acb46c923f6.jpg', 
        role: 'MEMBER'
      ),
      Participant(
        userId: '9f1c2d3e-4a5b-678c-9d0e-f1a2b3c4d5g8', 
        name: 'Rainbowwwwwwwwwwwwwwwwwwwwwwwww', 
        imagePath: 'https://i.pinimg.com/1200x/d4/a3/c2/d4a3c2cf522a1880a3c519c1f3d9257e.jpg', 
        role: 'MEMBER'
      ),
      Participant(
        userId: 'c1e8a245-9f73-4d62-8b0e-3a7c51f96a9c', 
        name: 'Applejack', 
        imagePath: 'https://i.pinimg.com/736x/1d/1c/43/1d1c430d3e82f15361cbffe4643a2029.jpg', 
        role: 'MEMBER'
      ),
      Participant(
        userId: '5d7a3b90-e214-4cfa-9b86-41f0d2e9a2c4', 
        name: 'Rarity', 
        imagePath: 'https://i.pinimg.com/736x/e7/48/08/e74808d81ad6ed6c730f3d52cb569d0e.jpg', 
        role: 'MEMBER'
      ),
    ],
    'a7d5e3b1-2c4f-47a8-9d6b-0f12c8e9789d': [
      Participant(
        userId: '7b8c9d0e-1f23-4567-89ab-cdef01264589', 
        name: 'Pinkie pie', 
        imagePath: 'https://i.pinimg.com/736x/c9/74/23/c97423c2b49f178612406acb46c923f6.jpg', 
        role: 'CREATOR'
      ),
      Participant(
        userId: '9f1c2d3e-4a5b-678c-9d0e-f1a2b3c4d5g8', 
        name: 'Rainbow', 
        role: 'MEMBER'
      ),
    ],
  };

  Future<List<Participant>> getParticipantsByGroup(String activityId) async {
    await Future.delayed(const Duration(milliseconds: 400)); // simulate network
    return _mockData[activityId] ?? [];
  }
}
