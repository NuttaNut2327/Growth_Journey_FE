import 'package:fe/interface/auth/user.dart';
import 'package:flutter/material.dart';
import 'package:fe/pages/heal/models/rank_model.dart';

class UserRankCard extends StatelessWidget {
  final User userRank;
  final bool isMe;
  const UserRankCard({super.key, required this.userRank,this.isMe = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFFF7EDF7) : Colors.white,
        borderRadius: BorderRadius.circular(21999),
        border: isMe ? Border.all(color: const Color(0x80E8C5E8), width: 2) : Border.all(color: const Color(0xFFF7EDF7), width: 2),
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
          Text(
            userRank.ranking == null ? "-" : "#${userRank.ranking}",
            style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 24),
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(userRank.imageUrl ?? 'https://i.pinimg.com/736x/dd/8b/a9/dd8ba98ba0b06489ac96f76b74fe7fc6.jpg'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userRank.username,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                'Level ${userRank.level}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF8B7A99)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}