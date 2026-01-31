import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'pages/login/login_page.dart';
import 'pages/login/register_page.dart';
import 'pages/home/home_page.dart';
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
        // AppRoutes.profile: (context) => const ProfilePage(),
      },
    );
  }
}
