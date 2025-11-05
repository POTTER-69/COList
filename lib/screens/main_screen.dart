
import 'package:colist_proj/screens/add_to_list/add_to_list.dart';
import 'package:colist_proj/screens/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/constants/app_assets.dart';
import '../utils/constants/app_colors.dart';
import 'archived_screen/archived_screen.dart';
import 'home_screen.dart';
import 'notifications_Screen/notifications_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const NotificationsScreen(),
    const AddToList(),
    const ArchivedScreen(),
    const SettingsScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          elevation: 1,
          selectedItemColor: AppColors.primaryColor,
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.home),
                label: "Home"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.notifications),
                label: "Notifications"),

            BottomNavigationBarItem(
                icon: Container(
                  width: 48.sp,
                  height: 48.sp,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child:
                  SvgPicture.asset(AppAssets.plus),

            ),
                label: "Add list"),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAssets.archive),
              label: 'Archived',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAssets.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}