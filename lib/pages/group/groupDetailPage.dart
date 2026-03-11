import 'package:fe/pages/group/repository/participant_repository.dart';
import 'package:fe/pages/group/repository/group_repository.dart';
import 'package:fe/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fe/widgets/backNavbar.dart';
import 'package:fe/widgets/tagGroup.dart';
import 'package:fe/pages/group/models/group_model.dart';
import 'package:fe/pages/group/models/participant_model.dart';
import 'package:fe/pages/group/chatGroupPage.dart';
import 'package:fe/pages/group/enum/role_participant.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:fe/widgets/bottomActionButton.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:fe/widgets/secondButton.dart';
import 'package:fe/widgets/participantCard.dart';
import 'package:fe/pages/group/editGroupPage.dart';
import 'package:fe/routes/app_routes.dart';
import 'package:fe/pages/group/enum/group_status.dart';

class GroupDetailPage extends StatefulWidget {
  const GroupDetailPage({super.key});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  final _groupRepository = GroupRepository();
  final _participantRepository = ParticipantRepository();
  late Group _group;
  late Future<Map<String, dynamic>> _groupFuture;
  bool _isInitialized = false;

  Future<Map<String, dynamic>> _loadData(String groupId) async {
    final userId = await getUserId();
    final participants = await _participantRepository.getParticipantsByGroup(
      groupId,
    );

    final isJoined = userId != null &&
        participants.any((participant) => participant.userId == userId);

    return {
      'participants': participants,
      'isJoined': isJoined,
      'userId': userId,
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) {
      return;
    }
    _group = ModalRoute.of(context)!.settings.arguments as Group;
    _groupFuture = _loadData(_group.id);
    _isInitialized = true;
  }

  Future<void> _refreshPage() async {
    setState(() {
      _groupFuture = _loadData(_group.id);
    });
    await _groupFuture;
  }

  Future<void> _handleJoin() async {
    try {
      await _groupRepository.joinGroup(_group.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Joined group successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      await _refreshPage();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join group: $e')),
      );
    }
  }

  Future<void> _handleLeave() async {
    try {
      await _groupRepository.leaveGroup(_group.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Left group successfully'),
        ),
      );
      await _refreshPage();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to leave group: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final group = _group;

    DateTime dateTime = DateTime.parse(group.date.toString());

    // Date format
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

    // Time format
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return FutureBuilder<Map<String, dynamic>>(
      future: _groupFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  Center(child: Text('Error: ${snapshot.error}')),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data!;
        final participants = data['participants'] as List<Participant>;
        final isJoined = data['isJoined'] as bool;
        final userId = data['userId'] as String?;
        final currentParticipant = userId == null
            ? null
            : participants
                .where((participant) => participant.userId == userId)
                .cast<Participant?>()
                .firstWhere((participant) => participant != null,
                    orElse: () => null);
        final isOwner = currentParticipant?.role == RoleParticipant.CREATOR;

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackNavbar(),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    group.image ??
                        'https://jkfenner.com/wp-content/uploads/2019/11/default.jpg',
                    width: double.infinity,
                    height: 180,
                    cacheHeight: 360,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: group.tags
                            .map((tag) => TagGroup(label: tag))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              group.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (isJoined)
                            _joinedBadge(isOwner
                                ? GroupStatus.OWNER.label
                                : GroupStatus.JOINED.label),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(group.description, style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedLocation01,
                            size: 20,
                            color: Color(0xFFD8A7D9),
                            strokeWidth: 1.5,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              group.location,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedCalendar04,
                            size: 20,
                            color: Color(0xFFD8A7D9),
                            strokeWidth: 1.5,
                          ),
                          const SizedBox(width: 12),
                          Text(formattedDate, style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 24),
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedClock01,
                            size: 20,
                            color: Color(0xFFD8A7D9),
                            strokeWidth: 1.5,
                          ),
                          const SizedBox(width: 12),
                          Text(formattedTime, style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '${participants.length}/${group.targetMemberCount} participants',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      participants.isEmpty
                          ? SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: Center(
                                child: Text(
                                  'No participants yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  spacing: 36,
                                  runSpacing: 24,
                                  children: participants.map((participant) {
                                    return ParticipantCard(
                                      participant: participant,
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomActionBar(
            context: context,
            group: group,
            isOwner: isOwner,
            isJoined: isJoined,
            onJoin: _handleJoin,
            onLeave: _handleLeave,
          ),
        );
      },
    );
  }
}

Widget _joinedBadge(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFF6DDE4),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF4A3A4A),
      ),
    ),
  );
}

Widget _buildBottomActionBar({
  required BuildContext context,
  required Group group,
  required bool isOwner,
  required bool isJoined,
  required Future<void> Function() onJoin,
  required Future<void> Function() onLeave,
}) {
  if (isOwner) {
    return BottomActionButton(
        text: '',
        onPressed: null,
        child: Row(
          children: [
            Expanded(
              child: SecondButton(
                text: 'Manage group',
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(40),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: MainButton(
                                        text: 'Edit group',
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.editGroup,
                                          );
                                        }),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: SecondButton(
                                        text: 'Delete group',
                                        onPressed: () {
                                          print('Delete group');
                                        }),
                                  ),
                                ]));
                      });
                },
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 44,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatGroupPage(group: group),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD8A7D9),
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedMessageMultiple02,
                  color: Colors.white,
                  size: 18,
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        ));
  }

  if (isJoined) {
    return BottomActionButton(
      text: '',
      onPressed: null,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: SecondButton(
                text: 'Leave group',
                onPressed: onLeave,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFD8A7D9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedMessageMultiple02,
                color: Colors.white,
                size: 18,
                strokeWidth: 2,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatGroupPage(group: group),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  return BottomActionButton(
    text: 'Join group',
    onPressed: onJoin,
  );
}
