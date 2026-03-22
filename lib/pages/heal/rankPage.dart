import 'package:flutter/material.dart';
import 'package:fe/widgets/PodiumCard.dart';
import 'package:fe/pages/heal/repository/rank_repository.dart';
import 'package:fe/widgets/userRankCard.dart';
import 'package:fe/api/auth/getUserByID.dart';
import 'package:fe/interface/auth/user.dart';
import 'package:hugeicons/hugeicons.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  final repo = UserRankRepository();
  final ScrollController _scrollController = ScrollController();

  int _myIndex = -1;
  int? _myRank;
  String? _myUserId;

  late Future<List<User>> _rankFuture;
  late Future<User> _meFuture;

  final GlobalKey _myRankKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _meFuture = getUserByID();
    _rankFuture = repo.getAllUserRanks();
  }

  void _scrollToMyRank() {
    final context = _myRankKey.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),

      body: FutureBuilder<List<User>>(
        future: _rankFuture,
        builder: (context, rankSnap) {
          if (!rankSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = rankSnap.data!;

          return FutureBuilder<User>(
            future: _meFuture,
            builder: (context, meSnap) {
              if (!meSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final me = meSnap.data!;
              _myUserId = me.id;    
              _myRank = me.ranking;

              _myIndex = users.indexWhere((u) => u.id == _myUserId);

              return Column(
                children: [
                  // แถบอันดับของเรา
                  GestureDetector(
                    onTap: _scrollToMyRank,
                    child: Container(
                      // margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0x4DC8E5D8),
                      ),
                      child: Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedStarAward01, 
                            size: 24, 
                            color: Color(0xFF5FA17B),
                            strokeWidth: 2,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "My Rank",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Text(
                            _myRank == null ? "-" : "#${_myRank}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // รายการอันดับ
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: users.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          final top3 = getTop3Unique(users);
                          return PodiumCard(topUsers: top3);
                        }

                        final user = users[index - 1];

                        final isMe = user.id == _myUserId;

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: AnimatedContainer(
                            key: isMe ? _myRankKey : null,
                            duration: const Duration(milliseconds: 300),
                            child: UserRankCard(
                              userRank: user,
                              isMe: isMe,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToMyRank,
        backgroundColor: Color(0xFFD8A7D9),
        child: const HugeIcon(
          icon: HugeIcons.strokeRoundedStarAward01, 
          size: 24, 
          strokeWidth: 2,
          color: Colors.white,
        ),
        shape: const CircleBorder(),
      ),
    );
  }
}

List<User> getTop3Unique(List<User> users) {
  final sorted = [...users]
    ..sort((a, b) {
      final rankA = a.ranking ?? 999999;
      final rankB = b.ranking ?? 999999;

      // เรียงตาม rank ก่อน
      final rankCompare = rankA.compareTo(rankB);
      if (rankCompare != 0) return rankCompare;

      // ถ้า rank ซ้ำ → คนที่อัปเดตก่อนชนะ
      final dateA = a.updatedAt ?? DateTime(9999);
      final dateB = b.updatedAt ?? DateTime(9999);
      return dateA.compareTo(dateB);
    });

  final usedRanks = <int>{};
  final result = <User>[];

  for (final user in sorted) {
    final rank = user.ranking;
    if (rank == null) continue;

    if (!usedRanks.contains(rank)) {
      usedRanks.add(rank);
      result.add(user);
    }

    if (result.length == 3) break;
  }

  return result;
}