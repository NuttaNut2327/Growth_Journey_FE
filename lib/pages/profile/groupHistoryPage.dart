import 'package:flutter/material.dart';
import 'package:fe/pages/profile/repository/activity_repository.dart';
import 'package:fe/pages/profile/models/activity_model.dart';
import 'package:fe/widgets/activityCard.dart';
import 'package:fe/routes/app_routes.dart';
import 'package:fe/pages/group/enum/role_participant.dart';
import 'package:fe/pages/group/models/group_model.dart';
import 'package:hugeicons/hugeicons.dart';

class GroupHistoryPage extends StatefulWidget {
  const GroupHistoryPage({super.key});

  @override
  State<GroupHistoryPage> createState() => _GroupHistoryPageState();
}

class _GroupHistoryPageState extends State<GroupHistoryPage> {
  late String type;
  bool isLoading = true;
  String? errorMessage;
  List<Activity> activities = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null) {
      type = args;
      loadActivities();
    }
  }

  Future<void> loadActivities() async {
    final ActivityRepository activityRepo = ActivityRepository();

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await activityRepo.getActivitiesByUserId();
      if (!mounted) return;

      final role = type == 'joined' ? RoleParticipant.MEMBER : RoleParticipant.CREATOR;
      setState(() {
        activities = data.where((a) => a.role == role).toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        activities = [];
        isLoading = false;
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Groups ${type == 'joined' ? 'participated' : 'created'}', 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
            strokeWidth: 2,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

    if (activities.isEmpty) {
      return const Center(
        child: Text(
          "No groups",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: activities.map((Activity activity) {
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
          padding: const EdgeInsets.only(bottom: 8),
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
}