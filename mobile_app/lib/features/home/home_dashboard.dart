import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

<<<<<<< HEAD
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  static const horizontalPadding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF6),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            _topHeader(context),
            const SizedBox(height: 20),
            Padding(
              padding: horizontalPadding,
              child: _weatherCard(context),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: horizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _offlineBanner(),
                  const SizedBox(height: 28),
                  const Text(
                    'What would you like to do today?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _quickActionGrid(context),
                  const SizedBox(height: 36),
                  _smartSuggestions(),
=======
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
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
                ],
              ),
            ),
          ],
        ),
      ),
<<<<<<< HEAD
      bottomNavigationBar: const AgriBottomNav(currentIndex: 0),
    );
  }

  // 🔝 HEADER
  Widget _topHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good Evening',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              SizedBox(height: 4),
              Text(
                'Welcome, Avantika',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // 👤 PROFILE NAVIGATION
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            child: Container(
              height: 42,
              width: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                ),
              ),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ☁️ WEATHER CARD
  Widget _weatherCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Navigator.pushNamed(context, AppRoutes.weather),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pune', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 6),
                Text(
                  '28°  Sunny',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Clear skies for next 3 days',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            Icon(Icons.wb_sunny, size: 46, color: Colors.yellow),
          ],
        ),
      ),
    );
  }

  // 🟠 OFFLINE BANNER
  Widget _offlineBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.deepOrange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'No internet connection. Some features may not work.',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ⚡ QUICK ACTIONS
  Widget _quickActionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.05,
      children: [
        _ActionCard(
          icon: Icons.chat,
          label: 'Ask AI',
          gradient: const [Color(0xFF66BB6A), Color(0xFF43A047)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.chatbot),
        ),
        _ActionCard(
          icon: Icons.agriculture,
          label: 'Crop Advice',
          gradient: const [Color(0xFF64B5F6), Color(0xFF1E88E5)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.cropInput),
        ),
        _ActionCard(
          icon: Icons.bar_chart,
          label: 'Market Prices',
          gradient: const [Color(0xFFFFB74D), Color(0xFFF57C00)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.market),
        ),
        _ActionCard(
          icon: Icons.cloud,
          label: 'Weather',
          gradient: const [Color(0xFF4DD0E1), Color(0xFF00838F)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.weather),
        ),
      ],
    );
  }

  // 🧠 SUGGESTIONS
  Widget _smartSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Today’s Smart Suggestions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 18),
        _Suggestion(
            color: Colors.green,
            icon: Icons.check_circle,
            text: 'Good day for sowing soybean'),
        _Suggestion(
            color: Colors.orange,
            icon: Icons.warning,
            text: 'Rain expected in 2 days'),
        _Suggestion(
            color: Colors.blue,
            icon: Icons.trending_up,
            text: 'Onion price high today in Pune mandi'),
      ],
    );
  }
}

class _Suggestion extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;

  const _Suggestion({
    required this.color,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// 🟢 ACTION CARD
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 14),
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
=======
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
    );
  }
}
