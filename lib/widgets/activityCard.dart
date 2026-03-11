import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/pages/group/models/group_model.dart';
import 'package:intl/intl.dart';

class ActivityCard extends StatelessWidget {
  final Group activity;

  const ActivityCard({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime = activity.date.toLocal();
    final formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF7EDF7),
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
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                (activity.image?.isEmpty ?? true)
                    ? 'https://jkfenner.com/wp-content/uploads/2019/11/default.jpg'
                    : activity.image!,
                width: 90,
                height: 90,
                cacheWidth: 180,
                cacheHeight: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedLocation01,
                      size: 14,
                      color: Color(0xFFD8A7D9),
                      strokeWidth: 2,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        activity.location,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ), 
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedCalendar04,
                      size: 14,
                      color: Color(0xFFD8A7D9),
                      strokeWidth: 2,
                    ),
                    SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedUserMultiple02,
                      size: 14,
                      color: Color(0xFFD8A7D9),
                      strokeWidth: 2,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "${activity.joinedMemberCount} participants",
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
