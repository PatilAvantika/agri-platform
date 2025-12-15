import 'package:flutter/material.dart';

// 🔹 Onboarding
import '../features/onboarding/splash_screen.dart';
import '../features/onboarding/language_select.dart';
import '../features/onboarding/location_setup.dart';
import '../features/onboarding/profile_screen.dart';

// 🔹 Home
import '../features/home/home_dashboard.dart';

// 🔹 Chatbot
import '../features/chatbot/chat_screen.dart';

// 🔹 Carbon Module
import '../features/carbon/carbon_overview.dart';
import '../features/carbon/carbon_input.dart';
import '../features/carbon/carbon_dashboard.dart';
import '../features/carbon/carbon_insights.dart';

// 🔹 Alerts
import '../features/alerts/alerts_screen.dart';

// 🔹 Settings / Help (future-safe)
import '../features/settings/setting_screen.dart';
import '../features/help/help_screen.dart';

class AppRoutes {
  // ================= ONBOARDING =================
  static const splash = '/';
  static const language = '/language';
  static const location = '/location';
  static const farmProfile = '/farm-profile';

  // ================= CORE =================
  static const home = '/home';
  static const chatbot = '/chatbot';

  // ================= CARBON =================
  static const carbonOverview = '/carbon-overview';
  static const carbonInput = '/carbon-input';
  static const carbonDashboard = '/carbon-dashboard';
  static const carbonInsights = '/carbon-insights';

  // ================= ALERTS =================
  static const alerts = '/alerts';

  // ================= EXTRA =================
  static const settings = '/settings';
  static const help = '/help';

  // ================= ROUTE MAP =================
  static final Map<String, WidgetBuilder> routes = {
    // Onboarding
    splash: (_) => const SplashScreen(),
    language: (_) => const LanguageSelectionScreen(),
    location: (_) => const LocationSetupScreen(),
    farmProfile: (_) => const BasicFarmProfileScreen(),

    // Core
    home: (_) => const HomeDashboardScreen(),
    chatbot: (_) => const ChatbotScreen(),

    // Carbon
    carbonOverview: (_) => const CarbonOverviewScreen(),
    carbonInput: (_) => const CarbonInputScreen(),
    carbonDashboard: (_) => const CarbonDashboardScreen(),
    carbonInsights: (_) => const CarbonInsightsScreen(),

    // Alerts
    alerts: (_) => const AlertsTipsScreen(),

    // Extra
    settings: (_) => const SettingsScreen(),
    help: (_) => const HelpHowItWorksScreen(),
  };
}
