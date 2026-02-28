import 'package:fe/pages/group/repository/participant_repository.dart';
import 'package:fe/services/group_page_service.dart';
import 'package:fe/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fe/widgets/backNavbar.dart';
import 'package:fe/widgets/tagGroup.dart';
import 'package:fe/pages/group/models/group_model.dart';
import 'package:fe/pages/group/models/participant_model.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:fe/widgets/bottomActionButton.dart';
import 'package:fe/widgets/secondButton.dart';
import 'package:fe/widgets/participantCard.dart';

class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({super.key});
  

  Future<Map<String, dynamic>> _loadData(String groupId) async {
    final userId = await getUserId();
    final participantRepository = ParticipantRepository();
    final participants = await participantRepository.getParticipantsByGroup(groupId);

    final isJoined =
        userId != null &&
        participants.any((participant) => participant.userId == userId );

    return {
      'participants': participants,
      'isJoined': isJoined,
      'userId': userId,
    };
  }

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)!.settings.arguments as Group;

    DateTime dateTime = DateTime.parse(group.date.toString()).toLocal();

    // Date format
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

    // Time format
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return FutureBuilder<Map<String, dynamic>>(
      future: _loadData(group.id),
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
                        children: group.tags != null
                            ? group.tags!
                                  .map((tag) => TagGroup(label: tag))
                                  .toList()
                            : [],
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
                          if (isJoined) _joinedBadge(),
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
                        '${group.joinedMemberCount}/${group.targetMemberCount} participants',
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
                                    color: Color(0xFFD8A7D9),
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
          bottomNavigationBar: isJoined
              ? BottomActionButton(
                  text: '',
                  onPressed: () {},
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: SecondButton(
                            text: 'Leave group',
                            onPressed: () {
                              print('leave group');
                            },
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
                            print('chat');
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : BottomActionButton(
                  text: 'Join group',
                  onPressed: () {
                    print('join group');
                  },
                ),
        );
      },
    );
  }
}

Widget _joinedBadge() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFF6DDE4),
      borderRadius: BorderRadius.circular(999),
    ),
    child: const Text(
      'Joined',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF4A3A4A),
      ),
    ),
  );
}
