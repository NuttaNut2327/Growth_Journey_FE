import 'package:fe/pages/group/enum/role_participant.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/tagGroup.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:fe/widgets/secondButton.dart';
import 'package:intl/intl.dart';
import 'package:fe/pages/group/models/group_model.dart';
import 'package:fe/pages/group/enum/group_status.dart';
import 'package:fe/pages/group/chatGroupPage.dart';

class GroupCard extends StatefulWidget {
  final Group group;
  final bool isJoined;
  final RoleParticipant? role;
  final Future<bool> Function()? onJoin;
  final Future<bool> Function()? onLeave;

  const GroupCard({
    super.key,
    required this.group,
    required this.isJoined,
    this.role,
    this.onJoin,
    this.onLeave,
  });

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  late bool _isJoined;
  late RoleParticipant? _role;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _isJoined = widget.isJoined;
    _role = widget.role;
  }

  @override
  void didUpdateWidget(covariant GroupCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isJoined != widget.isJoined ||
        oldWidget.role != widget.role) {
      _isJoined = widget.isJoined;
      _role = widget.role;
    }
  }

  Future<void> _handleJoin() async {
    if (_isProcessing || widget.onJoin == null) {
      return;
    }
    setState(() {
      _isProcessing = true;
    });
    final success = await widget.onJoin!.call();
    if (!mounted) {
      return;
    }
    if (success) {
      setState(() {
        _isJoined = true;
        _role = RoleParticipant.MEMBER;
      });
    }
    setState(() {
      _isProcessing = false;
    });
  }

  Future<void> _handleLeave() async {
    if (_isProcessing || widget.onLeave == null) {
      return;
    }
    setState(() {
      _isProcessing = true;
    });
    final success = await widget.onLeave!.call();
    if (!mounted) {
      return;
    }
    if (success) {
      setState(() {
        _isJoined = false;
        _role = null;
      });
    }
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
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
              if (_role == RoleParticipant.CREATOR)
                _joinedBadge(GroupStatus.OWNER.label),
              if (_isJoined && _role == RoleParticipant.MEMBER)
                _joinedBadge(GroupStatus.JOINED.label),
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
              cacheHeight: 240,
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
              Expanded(
                child: Text(
                  group.location,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, 
                  style: TextStyle(
                    fontSize: 12
                  )
                ),
              )
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
                overflow: TextOverflow.ellipsis,
                maxLines: 1, 
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: group.tags.map((tag) => TagGroup(label: tag)).toList(),
          ),
          const SizedBox(height: 16),
          if (_isJoined && _role != RoleParticipant.CREATOR)
            _joinedButton(
              context,
              group,
              _isProcessing ? null : _handleLeave,
            )
          else if (!_isJoined)
            _joinButton(_isProcessing ? null : _handleJoin),
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

Widget _joinedButton(
  BuildContext context,
  Group group,
  Future<void> Function()? onLeave,
) {
  return Row(
    children: [
      Expanded(
        child: SecondButton(
          text: 'Leave group',
          onPressed: () {
            onLeave?.call();
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
  );
}

Widget _joinButton(Future<void> Function()? onJoin) {
  return SizedBox(
    width: double.infinity,
    child: MainButton(
      text: 'Join group',
      onPressed: onJoin == null
          ? null
          : () async {
              await onJoin();
            },
    ),
  );
}
