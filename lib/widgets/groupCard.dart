import 'package:fe/pages/group/enum/role_participant.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/tagGroup.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:fe/widgets/secondButton.dart';
import 'package:intl/intl.dart';
import 'package:fe/pages/group/models/group_model.dart';
import 'package:fe/pages/group/enum/group_status.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final bool isJoined;
  final RoleParticipant? role;

  const GroupCard({
    super.key,
    required this.group,
    required this.isJoined,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy').format(group.date);
    String formattedTime = DateFormat('h:mm a').format(group.date);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF7EDF7), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(group.title, style: TextStyle(fontWeight: FontWeight.w700)),
              if (role == RoleParticipant.CREATOR)
                _joinedBadge(GroupStatus.OWNER.label),
              if (isJoined && role == RoleParticipant.MEMBER)
                _joinedBadge(GroupStatus.JOINED.label),
              if (!isJoined) _joinedBadge(GroupStatus.NOT_JOINED.label),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              group.image ??
                  'https://jkfenner.com/wp-content/uploads/2019/11/default.jpg',
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            group.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Color(0xFF8B7A99)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedLocation01,
                size: 14,
                color: Color(0xFFD8A7D9),
                strokeWidth: 1.5,
              ),
              const SizedBox(width: 8),
              Text(group.location, style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedCalendar04,
                size: 14,
                color: Color(0xFFD8A7D9),
                strokeWidth: 1.5,
              ),
              const SizedBox(width: 8),
              Text(formattedDate, style: TextStyle(fontSize: 12)),
              const SizedBox(width: 24),
              HugeIcon(
                icon: HugeIcons.strokeRoundedClock01,
                size: 14,
                color: Color(0xFFD8A7D9),
                strokeWidth: 1.5,
              ),
              const SizedBox(width: 8),
              Text(formattedTime, style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedUserMultiple02,
                size: 14,
                color: Color(0xFFD8A7D9),
                strokeWidth: 1.5,
              ),
              const SizedBox(width: 8),
              Text(
                '${group.joinedMemberCount}/${group.targetMemberCount} participants',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                group.tags?.map((tag) => TagGroup(label: tag)).toList() ?? [],
          ),
          const SizedBox(height: 16),
          if (isJoined) _joinedButton(role == RoleParticipant.CREATOR) else if (!isJoined) _joinButton(),
        ],
      ),
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

Widget _joinedButton(bool isOwner) {
  return Row(
    children: [
      Expanded(
        child: Opacity(
          opacity: isOwner ? 0.5 : 1.0, 
          child: SecondButton(
            text: 'Leave group',
            onPressed: isOwner ? () {} : () {},
          ),
        ),
      ),
      const SizedBox(width: 12),
      Opacity(
        opacity: isOwner ? 0.5 : 1.0,
        child: SizedBox(
          width: 44,
          height: 44,
          child: ElevatedButton(
            onPressed: isOwner
                ? null
                : () {
                    // Logic 
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD8A7D9),
              disabledBackgroundColor: const Color(0xFFD8A7D9).withOpacity(0.3),
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
      ),
    ],
  );
}

Widget _joinButton() {
  return SizedBox(
    width: double.infinity,
    child: MainButton(text: 'Join group', onPressed: () {}),
  );
}
