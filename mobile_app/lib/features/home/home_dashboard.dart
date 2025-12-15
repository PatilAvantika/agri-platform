import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

/// HomeDashboardScreen
/// -------------------
/// Purpose:
/// - Central hub for the app
/// - Entry point for all core features
///
///

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔶 OFFLINE AWARENESS BANNER (UI-ONLY)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.wifi_off, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No internet connection. Some features may not work.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 👋 Welcome Header
              Text(
                'Welcome to Agri Bot',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 8),

              Text(
                'Choose what you want to do today',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade800,
                    ),
              ),

              const SizedBox(height: 28),

              // 🚜 MAIN ACTION CARDS
              Expanded(
                child: Column(
                  children: [
                    // 🌱 Ask Agri Bot
                    DashboardActionCard(
                      icon: Icons.chat,
                      title: 'Ask Agri Bot',
                      description:
                          'Get farming advice and answers to your questions',
                      backgroundColor: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF2E7D32),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.chatbot);
                      },
                    ),

                    const SizedBox(height: 20),

                    // ♻ Carbon Credits
                    DashboardActionCard(
                      icon: Icons.eco,
                      title: 'Carbon Credits',
                      description: 'Track your impact and earn carbon credits',
                      backgroundColor: const Color(0xFFE3F2FD),
                      iconColor: const Color(0xFF1565C0),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.carbonOverview);
                      },
                    ),

                    const SizedBox(height: 20),

                    // 🚨 Alerts & Tips
                    DashboardActionCard(
                      icon: Icons.notifications,
                      title: 'Alerts & Tips',
                      description: 'Daily reminders and useful farming tips',
                      backgroundColor: const Color(0xFFFFF8E1),
                      iconColor: const Color(0xFFF9A825),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.alerts);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // 🟢 BOTTOM NAVIGATION (HOME ACTIVE)
      bottomNavigationBar: const AgriBottomNav(currentIndex: 0),
    );
  }
}

/// ------------------------------------------------------------
/// DashboardActionCard
/// Large, farmer-friendly navigation card
/// ------------------------------------------------------------
class DashboardActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const DashboardActionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 130), // BIG TAP AREA
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 34,
                color: iconColor,
              ),
            ),

            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
