import 'package:fe/services/group_page_service.dart';
import 'package:flutter/material.dart';
import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:hugeicons/hugeicons.dart';
import '/routes/app_routes.dart';
import 'package:fe/widgets/groupCard.dart';
import 'package:fe/pages/group/repository/group_repository.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final service = GroupPageService();
  final _groupRepository = GroupRepository();
  late Future<GroupPageData> _groupFuture;

  @override
  void initState() {
    super.initState();
    _groupFuture = service.load();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _groupFuture = service.load();
    });
    await _groupFuture;
  }

  Future<bool> _handleJoinGroup(String groupId) async {
    try {
      await _groupRepository.joinGroup(groupId);
      if (!mounted) {
        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Joined group successfully')),
      );
      return true;
    } catch (e) {
      if (!mounted) {
        return false;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to join group: $e')));
      return false;
    }
  }

  Future<bool> _handleLeaveGroup(String groupId) async {
    try {
      await _groupRepository.leaveGroup(groupId);
      if (!mounted) {
        return false;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Left group successfully')));
      return true;
    } catch (e) {
      if (!mounted) {
        return false;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to leave group: $e')));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFFD8A7D9),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                const MainUpperNavBar(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Growing Together',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'A small space for coming together\nand doing activities together.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8B7A99),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            AppRoutes.createGroup,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Color(0xFFD8A7D9),
                          foregroundColor: Color(0xFFFFFFFF),
                        ),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedAdd01,
                          size: 24,
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FutureBuilder<GroupPageData>(
                  future: _groupFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            Text("Error loading groups: ${snapshot.error}"),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _handleRefresh,
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      );
                    }

                    final data = snapshot.data!;
                    final groups = data.allGroups;
                    final joinedGroups = data.joinedGroups;

                    return Column(
                      children: groups.map((group) {
                        final membership =
                            joinedGroups.cast<dynamic>().firstWhere(
                                  (g) => g.groupId == group.id,
                                  orElse: () => null,
                                );

                        final bool isJoined = membership != null;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                AppRoutes.groupDetail,
                                arguments: group,
                              );

                              if (result == true) {
                                await _handleRefresh();
                              }
                            },
                            child: GroupCard(
                              group: group,
                              isJoined: isJoined,
                              role: isJoined ? membership.role : null,
                              onJoin: () => _handleJoinGroup(group.id),
                              onLeave: () => _handleLeaveGroup(group.id),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
