import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

/// AgriBottomNav
/// --------------
/// Purpose:
/// - Persistent navigation for farmers
/// - Prevents getting lost in the app
/// - One-tap access to core features
///
/// Tabs:
/// 0 → Home
/// 1 → Ask Agri Bot
/// 2 → Carbon
/// 3 → Alerts
///
/// UX:
/// - Large icons
/// - Clear labels
/// - High contrast
/// - Safe navigation using pushReplacement

class AgriBottomNav extends StatelessWidget {
  final int currentIndex;

  const AgriBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return; // 🚫 avoid reloading same screen

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.chatbot);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.carbonOverview);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.alerts);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),

      // 🎯 UX tuning for farmers
      iconSize: 30,
      selectedFontSize: 14,
      unselectedFontSize: 13,
      selectedItemColor: Colors.green.shade700,
      unselectedItemColor: Colors.grey.shade600,
      type: BottomNavigationBarType.fixed,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Ask',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.eco),
          label: 'Carbon',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
      ],
    );
  }
}
