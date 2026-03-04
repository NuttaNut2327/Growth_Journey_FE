import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  // final String title;
  // final String location;
  // final String date;
  // final String participants;
  // final String imageUrl;

  const ActivityCard({
    super.key,
    // required this.title,
    // required this.location,
    // required this.date,
    // required this.participants,
    // required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              // imageUrl,
              "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // title,
                  "Morning Meditation",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Text(location),
                // Text(date),
                // Text(participants),
                Text("Central Botanical Gardens"),
                Text("24 Dec 2025"),
                Text("8 participants"),
              ],
            ),
          )
        ],
      ),
    );
  }
}