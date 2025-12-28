import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class FarmInfoService {
  static const String _farmInfoKey = 'farm_info';

  // Get SharedPreferences instance
  static Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  /// Save farm information to local storage
  static Future<void> saveFarmInfo(UserProfile profile) async {
    try {
      final prefs = await _prefs;
      final farmInfoJson = jsonEncode({
        'farmArea': profile.farmArea,
        'farmAreaUnit': profile.farmAreaUnit,
        'cropTypes': profile.cropTypes,
        'farmingType': profile.farmingType,
        'irrigation': profile.irrigation,
        'soilType': profile.soilType,
        'farmingExperience': profile.farmingExperience,
      });
      await prefs.setString(_farmInfoKey, farmInfoJson);
    } catch (e) {
      throw Exception('Failed to save farm info: $e');
    }
  }

  /// Get farm information from local storage
  static Future<Map<String, dynamic>> getFarmInfo() async {
    try {
      final prefs = await _prefs;
      final farmInfoString = prefs.getString(_farmInfoKey);
      
      if (farmInfoString == null || farmInfoString.isEmpty) {
        return {
          'farmArea': 0.0,
          'farmAreaUnit': 'Acres',
          'cropTypes': [],
          'farmingType': '',
          'irrigation': '',
          'soilType': '',
          'farmingExperience': 0,
        };
      }

      final farmInfoJson = jsonDecode(farmInfoString);
      return {
        'farmArea': farmInfoJson['farmArea'] ?? 0.0,
        'farmAreaUnit': farmInfoJson['farmAreaUnit'] ?? 'Acres',
        'cropTypes': List<String>.from(farmInfoJson['cropTypes'] ?? []),
        'farmingType': farmInfoJson['farmingType'] ?? '',
        'irrigation': farmInfoJson['irrigation'] ?? '',
        'soilType': farmInfoJson['soilType'] ?? '',
        'farmingExperience': farmInfoJson['farmingExperience'] ?? 0,
      };
    } catch (e) {
      return {
        'farmArea': 0.0,
        'farmAreaUnit': 'Acres',
        'cropTypes': [],
        'farmingType': '',
        'irrigation': '',
        'soilType': '',
        'farmingExperience': 0,
      };
    }
  }

  /// Get available crop types
  static List<String> getAvailableCrops() {
    return [
      'Rice',
      'Wheat',
      'Cotton',
      'Soybean',
      'Sugarcane',
      'Maize',
      'Groundnut',
      'Chickpea',
      'Tomato',
      'Onion',
      'Potato',
      'Cabbage',
      'Brinjal',
      'Chili',
      'Turmeric',
      'Ginger',
      'Banana',
      'Mango',
      'Orange',
      'Grapes',
    ];
  }

  /// Get farming type options
  static List<String> getFarmingTypes() {
    return [
      'Organic Farming',
      'Conventional Farming',
      'Mixed Farming',
      'Monoculture',
      'Intercropping',
      'Polyculture',
      'Hydroponics',
      'Aquaponics',
      'Vertical Farming',
      'Permaculture',
    ];
  }

  /// Get irrigation type options
  static List<String> getIrrigationTypes() {
    return [
      'Drip Irrigation',
      'Sprinkler System',
      'Flood Irrigation',
      'Canal Irrigation',
      'Borewell',
      'Rainwater Harvesting',
      'Manual Watering',
      'Center Pivot',
      'Furrow Irrigation',
      'Subsurface Irrigation',
    ];
  }

  /// Get soil type options
  static List<String> getSoilTypes() {
    return [
      'Clay Soil',
      'Sandy Soil',
      'Loamy Soil',
      'Silt Soil',
      'Peat Soil',
      'Chalky Soil',
      'Saline Soil',
      'Alkaline Soil',
      'Acidic Soil',
      'Neutral Soil',
    ];
  }

  /// Get farm area unit options
  static List<String> getFarmAreaUnits() {
    return [
      'Acres',
      'Hectares',
      'Bigha',
      'Guntha',
      'Sq. Feet',
      'Sq. Meters',
    ];
  }

  /// Validate farm information
  static Map<String, String> validateFarmInfo({
    required double farmArea,
    required String farmAreaUnit,
    required List<String> cropTypes,
    required String farmingType,
    required String irrigation,
    required String soilType,
    required int farmingExperience,
  }) {
    final errors = <String, String>{};

    if (farmArea <= 0) {
      errors['farmArea'] = 'Farm area must be greater than 0';
    } else if (farmArea > 10000) {
      errors['farmArea'] = 'Farm area seems too large. Please check.';
    }

    if (farmAreaUnit.isEmpty) {
      errors['farmAreaUnit'] = 'Please select farm area unit';
    }

    if (cropTypes.isEmpty) {
      errors['cropTypes'] = 'Please select at least one crop type';
    }

    if (farmingType.isEmpty) {
      errors['farmingType'] = 'Please select farming type';
    }

    if (irrigation.isEmpty) {
      errors['irrigation'] = 'Please select irrigation type';
    }

    if (soilType.isEmpty) {
      errors['soilType'] = 'Please select soil type';
    }

    if (farmingExperience < 0) {
      errors['farmingExperience'] = 'Farming experience cannot be negative';
    } else if (farmingExperience > 100) {
      errors['farmingExperience'] = 'Farming experience seems unrealistic';
    }

    return errors;
  }

  /// Calculate carbon credits estimate
  static double calculateCarbonCredits({
    required double farmArea,
    required String farmingType,
    required List<String> cropTypes,
  }) {
    double baseCredits = farmArea * 0.5;

    // Adjust based on farming type
    switch (farmingType) {
      case 'Organic Farming':
        baseCredits *= 1.2;
        break;
      case 'Mixed Farming':
        baseCredits *= 1.1;
        break;
      case 'Conventional Farming':
        baseCredits *= 0.9;
        break;
    }

    // Adjust based on crop types
    if (cropTypes.contains('Rice')) {
      baseCredits *= 0.8; // Rice typically has lower carbon sequestration
    } else if (cropTypes.contains('Turmeric') || cropTypes.contains('Ginger')) {
      baseCredits *= 1.15; // These crops have good carbon sequestration
    }

    return baseCredits.clamp(0.0, 10.0);
  }

  /// Get trust score based on farm information completeness
  static int calculateTrustScore(UserProfile profile) {
    int score = 0;

    // Basic profile completion (40 points)
    if (profile.name.isNotEmpty) score += 10;
    if (profile.location.isNotEmpty) score += 10;
    if (profile.phone.isNotEmpty) score += 10;
    if (profile.bio.isNotEmpty) score += 10;

    // Farm information completion (40 points)
    if (profile.farmArea > 0) score += 10;
    if (profile.cropTypes.isNotEmpty) score += 10;
    if (profile.farmingType.isNotEmpty) score += 5;
    if (profile.irrigation.isNotEmpty) score += 5;
    if (profile.soilType.isNotEmpty) score += 5;
    if (profile.farmingExperience > 0) score += 5;

    // Verification status (20 points)
    if (profile.identityVerified) score += 10;
    if (profile.satelliteDataVerified) score += 5;
    if (profile.activityPhotosSubmitted) score += 3;
    if (!profile.seasonalValidationPending) score += 2;

    return score.clamp(0, 100);
  }

  /// Delete farm information
  static Future<void> deleteFarmInfo() async {
    try {
      final prefs = await _prefs;
      await prefs.remove(_farmInfoKey);
    } catch (e) {
      throw Exception('Failed to delete farm info: $e');
    }
  }
}

