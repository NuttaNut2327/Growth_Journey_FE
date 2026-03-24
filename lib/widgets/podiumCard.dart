import 'package:fe/interface/auth/user.dart';
import 'package:flutter/material.dart';

class PodiumCard extends StatelessWidget {
  final List<User> topUsers;

  const PodiumCard({super.key, required this.topUsers});

  @override
  Widget build(BuildContext context) {
    if (topUsers.length < 3) return const SizedBox();

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x33D8A7D9),
              Color(0x33C8E5D8),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _podiumItem(topUsers[1], 2, 110),
            const SizedBox(width: 18),
            _podiumItem(topUsers[0], 1, 150, isChampion: true),
            const SizedBox(width: 18),
            _podiumItem(topUsers[2], 3, 95),
          ],
        ),
      ),
    );
  }

  Widget _podiumItem(User user, int rank, double height,
      {bool isChampion = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isChampion)
          Image.asset(
            'assets/images/crown.png',
            width: 34,
            height: 34,
          ),
        CircleAvatar(
          radius: isChampion ? 40 : 32,
          backgroundImage: NetworkImage(user.imageUrl ?? 'https://i.pinimg.com/736x/dd/8b/a9/dd8ba98ba0b06489ac96f76b74fe7fc6.jpg'),
        ),
        const SizedBox(height: 12),
        Text(user.username,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color:Color(0xFFF6DDE4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("Level ${user.level}",
              style: const TextStyle(fontSize: 11)),
        ),
        const SizedBox(height: 16),
        Container(
          width: 88,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF3E5F5), // อ่อนสุด (บน)
                Color(0xFFE1BEE7), // กลาง
                Color(0xFFD8A7D9), // เข้มสุด (ล่าง)
              ],
              stops: [0.0, 0.45, 1.0],
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            "$rank",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4458),
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}