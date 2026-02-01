import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'pages/login/loginPage.dart';
import 'pages/login/registerPage.dart';
import 'pages/home/homePage.dart';
import 'package:fe/pages/blog/blogPage.dart';
import 'package:fe/pages/group/groupPage.dart';
import 'package:fe/pages/map/mapPage.dart';
import 'package:fe/pages/heal/healPage.dart';
import 'package:fe/pages/home/bottonNavBar.dart';
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
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.blog: (context) => const BlogPage(),
        AppRoutes.group: (context) => const GroupPage(),
        AppRoutes.map: (context) => const MapPage(),
        AppRoutes.heal: (context) => const HealPage(),
        AppRoutes.bottonnavbar: (context) => const Bottonnavbar(),
        // AppRoutes.profile: (context) => const ProfilePage(),
      },
    );
  }
}
