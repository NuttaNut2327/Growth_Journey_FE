import 'package:fe/pages/map/mapPage.dart';
import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'pages/login/loginPage.dart';
import 'pages/login/registerPage.dart';
import 'package:fe/widgets/bottomNavBar.dart';
import 'package:fe/pages/assessment/assessmentPage.dart';
import 'package:fe/pages/group/groupDetailPage.dart';
import 'package:fe/pages/group/createGroupPage.dart';
import 'package:fe/pages/blog/createBlogPage.dart';
import 'package:fe/pages/map/createLocationPage.dart';
// import 'pages/profile/profile_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter FE Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFFEF8FC),
      ),
      initialRoute: AppRoutes.bottomnavbar,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),

        AppRoutes.bottomnavbar: (context) => const Bottomnavbar(),

        AppRoutes.createGroup: (context) => const CreateGroupPage(),
        AppRoutes.groupDetail: (_) => const GroupDetailPage(),   
        AppRoutes.assessment: (context) => const AssessmentPage(),
        // AppRoutes.profile: (context) => const ProfilePage(),

        AppRoutes.createBlog: (context) => const CreateBlogPage(),
        AppRoutes.createLocation: (context) => const CreateLocationPage(),
        AppRoutes.map: (context) => const MapPage(), // Assuming MapPage is part of Bottomnavbar
      },
    );
  }
}
