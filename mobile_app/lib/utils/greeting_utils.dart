import 'package:intl/intl.dart';

class GreetingUtils {
  /// Get time-based greeting based on current time
  static String getTimeBasedGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  /// Get time-based greeting with user's name
  static String getPersonalizedGreeting(String userName) {
    final greeting = getTimeBasedGreeting();
    final name = userName.trim().isEmpty ? 'User' : userName.trim();
    return '$greeting, $name';
  }

  /// Get greeting for welcome header
  static String getWelcomeHeader(String userName) {
    final name = userName.trim().isEmpty ? 'User' : userName.trim();
    return 'Hello, $name';
  }

  /// Get greeting text for the day
  static String getGreetingText() {
    return 'Welcome back';
  }

  /// Get current time formatted
  static String getCurrentTimeFormatted() {
    return DateFormat('h:mm a').format(DateTime.now());
  }

  /// Get current day name
  static String getCurrentDayName() {
    return DateFormat('EEEE').format(DateTime.now());
  }

  /// Get current date formatted
  static String getCurrentDateFormatted() {
    return DateFormat('MMMM d, yyyy').format(DateTime.now());
  }

  /// Check if it's morning time
  static bool isMorning() {
    final hour = DateTime.now().hour;
    return hour >= 5 && hour < 12;
  }

  /// Check if it's afternoon time
  static bool isAfternoon() {
    final hour = DateTime.now().hour;
    return hour >= 12 && hour < 17;
  }

  /// Check if it's evening time
  static bool isEvening() {
    final hour = DateTime.now().hour;
    return hour >= 17 && hour < 21;
  }

  /// Check if it's night time
  static bool isNight() {
    final hour = DateTime.now().hour;
    return hour >= 21 || hour < 5;
  }

  /// Get appropriate emoji for greeting
  static String getGreetingEmoji() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return '🌅'; // Sunrise
    } else if (hour >= 12 && hour < 17) {
      return '☀️'; // Sun
    } else if (hour >= 17 && hour < 21) {
      return '🌆'; // Sunset
    } else {
      return '🌙'; // Moon
    }
  }

  /// Get greeting with emoji
  static String getGreetingWithEmoji(String userName) {
    final greeting = getPersonalizedGreeting(userName);
    final emoji = getGreetingEmoji();
    return '$emoji $greeting';
  }
}
