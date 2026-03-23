import 'package:fe/api/auth/getAllUserWithRanking.dart';
import 'package:fe/interface/auth/user.dart';

class UserRankRepository {

  Future<List<User>> getAllUserRanks() async {
    try {
      final users = await getAllUsersWithRanking();
      return users;
    } catch (e) {
      throw Exception('Failed to fetch user ranks: $e');
    }
  }
}
