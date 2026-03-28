import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  static const _routes = [
    '/home',
    '/reports',
    '/trends',
    '/doctor-visit',
    '/profile',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurfaceColor : Colors.white;
    final divider = isDark ? AppColors.darkBorderColor  : AppColors.borderColor;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: divider, width: 1)),
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) context.go(_routes[index]);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: bgColor,
        selectedItemColor: AppColors.zyvoTeal,
        unselectedItemColor: isDark ? AppColors.darkTextColorLight : AppColors.textColorLight,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_present_outlined),
            activeIcon: Icon(Icons.file_present),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            activeIcon: Icon(Icons.medical_services),
            label: 'Doctor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
