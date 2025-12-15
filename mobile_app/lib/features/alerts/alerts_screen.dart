import 'package:flutter/material.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

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

class AlertsTipsScreen extends StatelessWidget {
  const AlertsTipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: const AgriBottomNav(currentIndex: 3),
    );
  }
}

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ),
          ),
        ],
      ),
    );
  }
}
