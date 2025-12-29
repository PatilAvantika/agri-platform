import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileService {
  static const String _profileKey = 'user_profile';

  // Get SharedPreferences instance
  static Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  /// Save user profile to local storage
  static Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final prefs = await _prefs;
      final profileJson = jsonEncode(profile.toJson());
      await prefs.setString(_profileKey, profileJson);
    } catch (e) {
      throw Exception('Failed to save profile: $e');
    }
  }

  /// Get user profile from local storage
  static Future<UserProfile> getUserProfile() async {
    try {
      final prefs = await _prefs;
      final profileString = prefs.getString(_profileKey);
      
      if (profileString == null || profileString.isEmpty) {
        // Return default profile if none exists
        return UserProfile.defaultProfile();
      }

      final profileJson = jsonDecode(profileString);
      return UserProfile.fromJson(profileJson);
    } catch (e) {
      // Return default profile if there's an error
      return UserProfile.defaultProfile();
    }
  }

  /// Check if user profile exists and is complete
  static Future<bool> hasCompleteProfile() async {
    try {
      final profile = await getUserProfile();
      return profile.isComplete;
    } catch (e) {
      return false;
    }
  }

  /// Get user's display name
  static Future<String> getDisplayName() async {
    try {
      final profile = await getUserProfile();
      return profile.displayName;
    } catch (e) {
      return 'User';
    }
  }

  /// Update specific profile fields
  static Future<void> updateProfileField(String field, String value) async {
    try {
      final profile = await getUserProfile();
      UserProfile updatedProfile;

      switch (field) {
        case 'name':
          updatedProfile = profile.copyWith(name: value);
          break;
        case 'location':
          updatedProfile = profile.copyWith(location: value);
          break;
        case 'phone':
          updatedProfile = profile.copyWith(phone: value);
          break;
        case 'bio':
          updatedProfile = profile.copyWith(bio: value);
          break;
        case 'profileImageUrl':
          updatedProfile = profile.copyWith(profileImageUrl: value);
          break;
        default:
          throw Exception('Unknown field: $field');
      }

      await saveUserProfile(updatedProfile);
    } catch (e) {
      throw Exception('Failed to update profile field: $e');
    }
  }

  /// Delete user profile (reset to default)
  static Future<void> deleteUserProfile() async {
    try {
      final prefs = await _prefs;
      await prefs.remove(_profileKey);
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  /// Get profile data as a map for UI display
  static Future<Map<String, dynamic>> getProfileData() async {
    try {
      final profile = await getUserProfile();
      return {
        'name': profile.name,
        'location': profile.location,
        'phone': profile.phone,
        'bio': profile.bio,
        'profileImageUrl': profile.profileImageUrl,
        'isComplete': profile.isComplete,
        'displayName': profile.displayName,
      };
    } catch (e) {
      return {
        'name': '',
        'location': '',
        'phone': '',
        'bio': '',
        'profileImageUrl': '',
        'isComplete': false,
        'displayName': 'User',
      };
    }
  }

  /// Validate profile data
  static Map<String, String> validateProfileData({
    required String name,
    required String location,
    String? phone,
    String? bio,
  }) {
    final errors = <String, String>{};

    if (name.trim().isEmpty) {
      errors['name'] = 'Name is required';
    } else if (name.trim().length < 2) {
      errors['name'] = 'Name must be at least 2 characters';
    }

    if (location.trim().isEmpty) {
      errors['location'] = 'Location is required';
    }

    if (phone != null && phone.isNotEmpty && phone.length != 10) {
      errors['phone'] = 'Phone number must be 10 digits';
    }

    if (bio != null && bio.length > 200) {
      errors['bio'] = 'Bio must be less than 200 characters';
    }

    return errors;
  }
}
