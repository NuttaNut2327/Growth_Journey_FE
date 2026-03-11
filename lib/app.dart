import 'package:fe/pages/map/mapPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fe/services/fcm_notification_service.dart';
import 'routes/app_routes.dart';
import 'pages/login/loginPage.dart';
import 'pages/login/registerPage.dart';
import 'package:fe/widgets/bottomNavBar.dart';
import 'package:fe/pages/assessment/assessmentPage.dart';
import 'package:fe/pages/group/groupDetailPage.dart';
import 'package:fe/pages/group/createGroupPage.dart';
import 'package:fe/pages/group/editGroupPage.dart';
import 'package:fe/pages/profile/profilePage.dart';
import 'package:fe/pages/profile/editProfilePage.dart';
import 'package:fe/pages/blog/createBlogPage.dart';
import 'package:fe/pages/map/createLocationPage.dart';
import 'package:fe/services/navigation_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FCMNotificationService? _fcmService;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initializeFCM();
    } else {
      print('⚠️ FCM Service not available on Web platform');
    }
  }

  Future<void> _initializeFCM() async {
    try {
      _fcmService = FCMNotificationService();
      await _fcmService!.initialize();
      print('✅ FCM Service initialized in MyApp');
    } catch (e) {
      print('🔴 Error initializing FCM: $e');
    }
  }

  @override
  void dispose() {
    _fcmService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter FE Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),

        AppRoutes.bottomnavbar: (context) => const Bottomnavbar(),

        AppRoutes.createGroup: (context) => const CreateGroupPage(),
        AppRoutes.editGroup: (context) => const EditGroupPage(),
        AppRoutes.groupDetail: (_) => const GroupDetailPage(),
        AppRoutes.assessment: (context) => const AssessmentPage(),
        AppRoutes.profile: (context) => const ProfilePage(),
        AppRoutes.editProfile: (context) => const EditProfilePage(),
        AppRoutes.createBlog: (context) => const CreateBlogPage(),
        AppRoutes.createLocation: (context) => const CreateLocationPage(),
        AppRoutes.map: (context) => const MapPage(),
      },
    );
  }
}
