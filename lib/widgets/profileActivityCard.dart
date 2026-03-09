import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileActivitiesCard extends StatefulWidget {
  const ProfileActivitiesCard({super.key});

  @override
  State<ProfileActivitiesCard> createState() => _ProfileActivitiesCardState();
}

class _ProfileActivitiesCardState extends State<ProfileActivitiesCard> {

  int selectedTab = 0;

  Widget buildTab(String title, int index) {
    final bool isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD7A8E6) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF7B6C8F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActivities() {

    if (selectedTab == 0) {
      /// Activities joined
      return const Column(
        children: [
          ActivityItem(),
          SizedBox(height: 12),
          ActivityItem(),
          SizedBox(height: 12),
          ActivityItem(),
        ],
      );
    }

    /// Activities created
    return const Column(
      children: [
        ActivityItem(),
        SizedBox(height: 12),
        ActivityItem(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0x4CF8ECF4),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFF7EDF7),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                buildTab("Activities joined", 0),
                buildTab("Activities created", 1),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// Title
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Activities Participated",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4C4456),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Your recent activity history",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8F839C),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Activities list
          buildActivities(),
        ],
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  const ActivityItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6D8EC)),
        color: Colors.white,
      ),
      child: Row(
        children: [

          /// Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              "https://images.unsplash.com/photo-1618220179428-22790b461013",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          /// Content
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Support Circle",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF4C4456),
                  ),
                ),

                SizedBox(height: 4),

                Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedLocation01,
                      size: 14,
                      strokeWidth: 1.8,
                      color: Color(0xFFD7A8E6),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Wellness Center Room 3",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7F748B),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2),

                Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedCalendar01,
                      size: 14,
                      strokeWidth: 1.8,
                      color: Color(0xFFD7A8E6),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "24 Dec 2025",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7F748B),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2),

                Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedUserMultiple02,
                      size: 14,
                      strokeWidth: 1.8,
                      color: Color(0xFFD7A8E6),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "6 participants",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7F748B),
                      ),
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