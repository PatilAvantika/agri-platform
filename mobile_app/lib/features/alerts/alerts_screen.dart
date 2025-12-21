import 'package:flutter/material.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

<<<<<<< HEAD
=======
/// AlertsTipsScreen
/// ----------------
/// Purpose:
/// - Show simple alerts, reminders, and tips
/// - Keep farmers engaged daily
///
/// UX Principles:
/// - Very simple list layout
/// - Large cards & text
/// - Icons + text together
/// - No complex actions
///
/// NOTE:
/// - UI only
/// - Placeholder alerts

>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
class AlertsTipsScreen extends StatelessWidget {
  const AlertsTipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: const Color(0xFFF4FAF6), // soft modern bg

      // 🔔 AppBar (clean like second image)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Alerts & Proactive Actions',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_active, color: Colors.green),
          )
        ],
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: ListView(
          key: const ValueKey('alerts'),
          padding: const EdgeInsets.all(20),
          children: const [
            AlertCard(
              type: AlertType.weather,
              title: 'Heavy Rain Expected Tomorrow',
              message: 'Cover stored crops and avoid fertilizer spraying.',
              action: 'Prepare drainage & protect harvest',
            ),
            SizedBox(height: 16),
            AlertCard(
              type: AlertType.pest,
              title: 'Pest Risk Detected',
              message: 'High humidity may cause pest infestation.',
              action: 'Inspect leaves and use neem-based spray',
            ),
            SizedBox(height: 16),
            AlertCard(
              type: AlertType.market,
              title: 'Onion Price Spike',
              message: 'Prices increased sharply in Pune mandi.',
              action: 'Good time to sell within next 2 days',
            ),
            SizedBox(height: 16),
            AlertCard(
              type: AlertType.sowing,
              title: 'Ideal Sowing Window',
              message: 'Soil moisture and temperature are favorable.',
              action: 'Start soybean sowing this week',
            ),
          ],
        ),
      ),

=======
      backgroundColor: Colors.white,

      // 🔔 AppBar
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Alerts & Tips',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: const [
              AlertTipCard(
                icon: Icons.eco,
                title: 'Carbon Tip',
                message:
                    'Planting more trees this season can increase your carbon credits.',
                backgroundColor: Color(0xFFE8F5E9),
                iconColor: Color(0xFF2E7D32),
              ),
              SizedBox(height: 16),
              AlertTipCard(
                icon: Icons.calendar_today,
                title: 'Seasonal Reminder',
                message:
                    'Prepare your land early for the upcoming sowing season.',
                backgroundColor: Color(0xFFFFF8E1),
                iconColor: Color(0xFFF9A825),
              ),
              SizedBox(height: 16),
              AlertTipCard(
                icon: Icons.water_drop,
                title: 'Water Saving Tip',
                message:
                    'Use drip irrigation to save water and improve crop health.',
                backgroundColor: Color(0xFFE3F2FD),
                iconColor: Color(0xFF1565C0),
              ),
              SizedBox(height: 16),
              AlertTipCard(
                icon: Icons.agriculture,
                title: 'Soil Health Tip',
                message:
                    'Reducing tillage helps improve soil health and lowers costs.',
                backgroundColor: Color(0xFFF1F8E9),
                iconColor: Color(0xFF558B2F),
              ),
            ],
          ),
        ),
      ),

      // 🟢 Bottom Navigation (Alerts tab active)
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
      bottomNavigationBar: const AgriBottomNav(currentIndex: 3),
    );
  }
}

<<<<<<< HEAD
/* -------------------------------------------------------------------------- */
/*                                ALERT CARD                                  */
/* -------------------------------------------------------------------------- */

enum AlertType { weather, pest, market, sowing }

class AlertCard extends StatelessWidget {
  final AlertType type;
  final String title;
  final String message;
  final String action;

  const AlertCard({
    Key? key,
    required this.type,
    required this.title,
    required this.message,
    required this.action,
=======
/// 🔔 AlertTipCard
/// Large, farmer-friendly alert card
class AlertTipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color backgroundColor;
  final Color iconColor;

  const AlertTipCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.iconColor,
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final config = _alertConfig(type);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🎨 LEFT COLOR STRIP (FINTECH STYLE)
          Container(
            width: 6,
            height: 140,
            decoration: BoxDecoration(
              color: config.color,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(18),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CATEGORY ROW
                  Row(
                    children: [
                      Icon(config.icon, color: config.color, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        config.label,
                        style: TextStyle(
                          color: config.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // MESSAGE
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 👉 ACTION
                  Row(
                    children: [
                      const Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.black45),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          action,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: config.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
=======
    return Container(
      constraints: const BoxConstraints(minHeight: 130), // 👈 Big tap area
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
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
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD

  _AlertUIConfig _alertConfig(AlertType type) {
    switch (type) {
      case AlertType.weather:
        return _AlertUIConfig(
          color: Colors.blue,
          icon: Icons.cloud,
          label: 'Weather Alert',
        );
      case AlertType.pest:
        return _AlertUIConfig(
          color: Colors.redAccent,
          icon: Icons.bug_report,
          label: 'Pest Risk',
        );
      case AlertType.market:
        return _AlertUIConfig(
          color: Colors.green,
          icon: Icons.trending_up,
          label: 'Market Alert',
        );
      case AlertType.sowing:
        return _AlertUIConfig(
          color: Colors.orange,
          icon: Icons.agriculture,
          label: 'Sowing Advice',
        );
    }
  }
}

class _AlertUIConfig {
  final Color color;
  final IconData icon;
  final String label;

  _AlertUIConfig({
    required this.color,
    required this.icon,
    required this.label,
  });
=======
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
}
