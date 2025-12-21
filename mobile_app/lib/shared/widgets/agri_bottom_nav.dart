import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

/// AgriBottomNav
/// --------------
/// Purpose:
/// - Persistent navigation for farmers
<<<<<<< HEAD
/// - Simple, predictable, one-tap access
/// - Prevents confusion & backstack issues
///
/// Tabs (FINAL):
/// 0 → Home
/// 1 → Ask Agri Bot
/// 2 → Market Prices
/// 3 → Carbon Impact
///
/// UX Principles:
=======
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
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
/// - Large icons
/// - Clear labels
/// - High contrast
/// - Safe navigation using pushReplacement

class AgriBottomNav extends StatelessWidget {
  final int currentIndex;

<<<<<<< HEAD
  const AgriBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
=======
  const AgriBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return; // 🚫 avoid reloading same screen
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.chatbot);
        break;
      case 2:
<<<<<<< HEAD
        Navigator.pushReplacementNamed(context, AppRoutes.market);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.carbonOverview);
=======
        Navigator.pushReplacementNamed(context, AppRoutes.carbonOverview);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.alerts);
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
<<<<<<< HEAD
      onTap: (i) => _onTap(context, i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green.shade700,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Ask'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Market'),
        BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Carbon'),
=======
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
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
      ],
    );
  }
}
