import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/pages/home/homePage.dart';
import 'package:fe/pages/blog/blogPage.dart';
import 'package:fe/pages/group/groupPage.dart';
import 'package:fe/pages/map/mapPage.dart';
import 'package:fe/pages/heal/healPage.dart';

class Bottonnavbar extends StatefulWidget {
  const Bottonnavbar({super.key});

  @override
  State<Bottonnavbar> createState() => _BottonnavbarState();
}

class _BottonnavbarState extends State<Bottonnavbar> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    BlogPage(),
    GroupPage(),
    MapPage(),
    HealPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFD8A7D9),
        unselectedItemColor: Color(0xFF8B7A99),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome07,
              size: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedQuillWrite01,
              size: 20,
            ),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUserGroup,
              size: 20,
            ),
            label: 'Group',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedLocation01,
              size: 20,
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedFavourite,
              size: 20,
            ), 
            label: 'Heal',
          ),
        ],
      ),
    );
  }
}

