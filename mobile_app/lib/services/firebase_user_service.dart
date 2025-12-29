import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class FirebaseUserService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Get current user phone number
  static String? getCurrentUserPhone() {
    final user = _auth.currentUser;
    return user?.phoneNumber;
  }

  /// Get current user display name
  static String? getCurrentUserDisplayName() {
    final user = _auth.currentUser;
    return user?.displayName;
  }

  /// Check if user is logged in
  static bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Get user ID
  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// Create or update profile with Firebase Auth data
  static UserProfile? createProfileFromAuth() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return UserProfile(
      id: user.uid,
      name: user.displayName ?? '',
      location: '',
      phone: user.phoneNumber ?? '',
      bio: '',
      profileImageUrl: user.photoURL ?? '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Sign out user
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Stream of auth state changes
  static Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }
}
