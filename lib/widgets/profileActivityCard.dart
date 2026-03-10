import 'package:flutter/material.dart';
import 'package:fe/pages/profile/repository/activity_repository.dart';
import 'package:fe/pages/profile/models/activity_model.dart';
import 'package:fe/widgets/activityCard.dart';
import 'package:fe/routes/app_routes.dart';
import 'package:fe/pages/group/enum/role_participant.dart';
import 'package:fe/pages/group/models/group_model.dart';

class ProfileActivitiesCard extends StatefulWidget {
  final String userId;
  const ProfileActivitiesCard({super.key, required this.userId});

  @override
  State<ProfileActivitiesCard> createState() => _ProfileActivitiesCardState();
}

class _ProfileActivitiesCardState extends State<ProfileActivitiesCard> {
  int selectedTab = 0;
  bool isLoading = true;
  String? errorMessage;
  List<Activity> joinedActivities = [];
  List<Activity> createdActivities = [];

  @override
  void initState() {
    super.initState();
    loadActivities();
  }

  Future<void> loadActivities() async {
    final ActivityRepository activityRepo = ActivityRepository();

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await activityRepo.getActivitiesByUserId(widget.userId);
      if (!mounted) return;

      setState(() {
        joinedActivities =
            data.where((a) => a.role == RoleParticipant.MEMBER).toList();

        createdActivities =
            data.where((a) => a.role == RoleParticipant.CREATOR).toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        joinedActivities = [];
        createdActivities = [];
        isLoading = false;
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: loadActivities,
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    final list = selectedTab == 0 ? joinedActivities : createdActivities;

    if (list.isEmpty) {
      return const Center(
        child: Text(
          "No activities",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      children: list.map((Activity activity) {
        final group = Group(
          id: activity.groupId,
          title: activity.title,
          image: activity.imagePath,
          description: activity.description,
          locationId: activity.locationId,
          location: activity.location,
          date: DateTime.tryParse(activity.eventDate) ?? DateTime.now(),
          joinedMemberCount: activity.joinedMemberCount,
          targetMemberCount: activity.targetMemberCount,
          tags: activity.tags,
          createdAt: activity.createdAt,
          createdBy: activity.createdBy,
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.groupDetail,
                arguments: group,
              );
            },
            child: ActivityCard(activity: group),
          ),
        );
      }).toList(),
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
          const Column(
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

          const SizedBox(height: 24),

          /// Activities list
          buildActivities(),
        ],
      ),
    );
  }
}
