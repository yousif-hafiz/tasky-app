import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/screens/home_screean/home_screean.dart';
import 'package:tasky/screens/profile_screen/profile_screen.dart';
import 'package:tasky/screens/tasks_screen/tasks_screen.dart';

import '../complete_task_screen/complete_tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screen = [
    HomeScreen(),
    TasksScreen(),
    CompleteTasksScreen(),
    ProfileScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int? index) {
          setState(() {
            _currentIndex = index ?? 0;
            //Null Coalescing Operator => ?? , إذا كانت القيمة على اليسار ليست null → استخدمها ,إذا كانت null → استخدم القيمة على اليمين
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomSvgPicture(
              path: "assets/images/homeIcon.svg",
              colorFilter: navIconColor(index: 0),
              width: 24,
              height: 24,
            ),
            /*SvgPicture.asset(
                          "assets/images/homeIcon.svg",
                          colorFilter: ColorFilter.mode(
                            _currentIndex == 0 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                            BlendMode.srcIn,
                          ),
                        ),*/
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: CustomSvgPicture(
              path: "assets/images/todoIcon.svg",
              colorFilter: navIconColor(index: 1), //3A4640, #14A662
              width: 24,
              height: 24,
            ),
            /*SvgPicture.asset(
                          "assets/images/todoIcon.svg",
                          colorFilter: ColorFilter.mode(
                            _currentIndex == 1 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                            BlendMode.srcIn,
                          ),
                        ),*/
            label: 'To Do',
          ),
          BottomNavigationBarItem(
            icon: CustomSvgPicture(
              path: "assets/images/CompletedIcon.svg",
              colorFilter: navIconColor(index: 2),
              width: 24,
              height: 24,
            ),
            /*SvgPicture.asset(
                          "assets/images/CompletedIcon.svg",
                          colorFilter: ColorFilter.mode(
                            _currentIndex == 2 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                            BlendMode.srcIn,
                          ),
                        ),*/
            label: "Completed",
          ),
          BottomNavigationBarItem(
            icon: CustomSvgPicture(
              path: "assets/images/ProfileIcon.svg",
              colorFilter: navIconColor(index: 3),
              width: 24,
              height: 24,
            ),
            /*SvgPicture.asset(
                          "assets/images/ProfileIcon.svg",
                          colorFilter: ColorFilter.mode(
                            _currentIndex == 3 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                            BlendMode.srcIn,
                          ),
                        ),*/
            label: "Profile",
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _screen[_currentIndex],
        ),
      ),
    );
  }

  Color navIconColor({required int index}) {
    return ThemeController.isDark()
        ? (_currentIndex == index ? Color(0xFF15B86C) : Color(0xFFC6C6C6))
        : (_currentIndex == index ? Color(0xFF14A662) : Color(0xFF3A4640));
  }
}
