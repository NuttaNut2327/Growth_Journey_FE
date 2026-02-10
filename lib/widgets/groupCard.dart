import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/tagGroup.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:fe/widgets/secondButton.dart';
import 'package:intl/intl.dart';


class GroupCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final String location;
  final String eventDate;
  final int joinedMemberCount;
  final int targetMemberCount;
  final List<String> tags;
  final String status;

  const GroupCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.joinedMemberCount,
    required this.targetMemberCount,
    required this.tags,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
  
    DateTime dateTime = DateTime.parse(eventDate).toLocal();

    // Date format
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

    // Time format
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFEEDFF1),
          width: 2,
        ),
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
              Text(
                title, 
                style: TextStyle(
                  fontWeight: FontWeight.w700
                )
              ),
              if (status.toLowerCase() == 'joined') _joinedBadge(),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description, 
            style: TextStyle(
              fontSize: 12, 
              color: Color(0xFF8B7A99)
            )
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedLocation01, size: 14, color: Color(0xFFD8A7D9), strokeWidth: 1.5,),
              const SizedBox(width: 8),
              Text(
                location,
                style: TextStyle(
                  fontSize: 12
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedCalendar04, size: 14, color: Color(0xFFD8A7D9), strokeWidth: 1.5,),
              const SizedBox(width: 8),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 12
                ),
              ),
              const SizedBox(width: 24),
              HugeIcon(icon: HugeIcons.strokeRoundedClock01, size: 14, color: Color(0xFFD8A7D9), strokeWidth: 1.5,),
              const SizedBox(width: 8),
              Text(
                formattedTime,
                style: TextStyle(
                  fontSize: 12
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedUserMultiple02, size: 14, color: Color(0xFFD8A7D9), strokeWidth: 1.5,),
              const SizedBox(width: 8),
              Text('$joinedMemberCount/$targetMemberCount participants',
              style: TextStyle(
                fontSize: 12
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map((tag) => TagGroup(label: tag))
                .toList(),
          ),
          const SizedBox(height: 16),
          if (status.toLowerCase() == 'joined')
            _joinedButton()
          else
            _joinButton(),
        ],
      ),
    );
  }
}

Widget _joinedBadge() {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 4,
    ),
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

Widget _joinedButton() {
  return Row(
    children: [
      Expanded(
        child: SecondButton(
          text: 'Leave group',
          onPressed: () {},
        ),
      ),
      const SizedBox(width: 12),
      SizedBox(
        width: 44,
        height: 44,
        child: ElevatedButton(
          onPressed: () {},
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

Widget _joinButton() {
  return SizedBox(
    width: double.infinity,
    child: MainButton(
      text: 'Join group',
      onPressed: () {},
    ),
  );
}
