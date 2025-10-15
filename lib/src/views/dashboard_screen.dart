import 'package:flutter/material.dart';
import 'package:leam/src/core/constants/app_colors.dart';
import 'package:leam/src/views/all_calls_screen.dart';
import 'package:leam/src/views/all_status_screen.dart';
import 'package:leam/src/views/chats_screen.dart';
import 'package:leam/src/views/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = [
    const ChatsScreen(),
    const AllCallsScreen(),
    const AllStatusScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _tabClick(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedLabelStyle: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            items: [
              BottomNavigationBarItem(label: "Chats", icon: Icon(Icons.chat)),

              BottomNavigationBarItem(label: "Calls", icon: Icon(Icons.call)),

              BottomNavigationBarItem(
                label: "Status",
                icon: Icon(Icons.update),
              ),

              BottomNavigationBarItem(
                label: "Settings",
                icon: Icon(Icons.settings),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _tabClick,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
          ),
        ),
      ),
    );
  }
}
