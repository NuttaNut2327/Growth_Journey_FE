import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/pages/home/homePage.dart';
import 'package:fe/pages/blog/blogPage.dart';
import 'package:fe/pages/group/groupPage.dart';
import 'package:fe/pages/map/mapPage.dart';
import 'package:fe/pages/heal/healPage.dart';

final GlobalKey<_BottomnavbarState> bottomNavKey = GlobalKey<_BottomnavbarState>();

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _currentIndex = 0;

  final List<Widget?> _pages = List<Widget?>.filled(5, null);

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const BlogPage();
      case 2:
        return const GroupPage();
      case 3:
        return const MapPage();
      case 4:
        return const HealPage();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    _pages[_currentIndex] ??= _buildPage(_currentIndex);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: List<Widget>.generate(
          _pages.length,
          (index) => _pages[index] ?? const SizedBox.shrink(),
        ),
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
